import 'dart:async';
import 'package:finager/models/dispatch_data.dart';
import 'package:finager/models/transaction.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';
import '../services/api_service.dart';

/// PreferencesService provider
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

/// StateNotifierProvider for the form
final transactionFormProvider =
    StateNotifierProvider<TransactionFormNotifier, TransactionFormState>((ref) {
      return TransactionFormNotifier(ref);
    });

enum SaveStatus { noChanges, failure, success }

class TransactionFormState {
  final bool isSendingData;
  final int? selectedPaymentMethod;
  final int? selectedCategory;
  final String? transactionType;
  final DateTime selectedDate;
  final int? selectedTruck;
  final TextEditingController amountController;
  final TextEditingController householdTotalTaken;
  final TextEditingController descriptionController;
  final TextEditingController driverNameController;

  TransactionFormState({
    required this.isSendingData,
    required this.selectedPaymentMethod,
    required this.selectedCategory,
    required this.transactionType,
    required this.selectedDate,
    required this.selectedTruck,
    required this.amountController,
    required this.householdTotalTaken,
    required this.descriptionController,
    required this.driverNameController,
  });

  TransactionFormState copyWith({
    bool? isSendingData,
    int? selectedPaymentMethod,
    int? selectedCategory,
    String? transactionType,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    int? selectedTruck,
    TextEditingController? amountController,
    TextEditingController? householdTotalTaken,
    TextEditingController? descriptionController,
    TextEditingController? driverNameController,
  }) {
    return TransactionFormState(
      isSendingData: isSendingData ?? this.isSendingData,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      transactionType: transactionType ?? this.transactionType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTruck: selectedTruck ?? this.selectedTruck,
      amountController: amountController ?? this.amountController,
      householdTotalTaken: householdTotalTaken ?? this.householdTotalTaken,
      descriptionController:
          descriptionController ?? this.descriptionController,
      driverNameController: driverNameController ?? this.driverNameController,
    );
  }
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  final Ref ref;

  TransactionFormNotifier(this.ref)
    : super(
        TransactionFormState(
          isSendingData: false,
          selectedPaymentMethod: null,
          selectedCategory: null,
          transactionType: null,
          selectedDate: DateTime.now(),
          selectedTruck: null,
          amountController: TextEditingController(),
          householdTotalTaken: TextEditingController(),
          descriptionController: TextEditingController(),
          driverNameController: TextEditingController(),
        ),
      );

  void settransactionType(String? v) =>
      state = state.copyWith(transactionType: v);

  void setSelectedCategory(int? v) =>
      state = state.copyWith(selectedCategory: v);

  void setPaymentMethod(int? v) =>
      state = state.copyWith(selectedPaymentMethod: v);

  void setTruck(int? v) => state = state.copyWith(selectedTruck: v);

  void setDate(DateTime d) =>
      state = state.copyWith(
        selectedDate: DateTime(d.year, d.month, d.day, d.hour, d.minute),
      );

  Future<void> pickDate(BuildContext ctx) async {
    final DateTime? picked = await showDatePicker(
      context: ctx,
      initialDate: state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigoAccent.withAlpha(220),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null && picked != state.selectedDate) {
      state = state.copyWith(
        selectedDate: DateTime(
          picked.year,
          picked.month,
          picked.day,
          state.selectedDate.hour,
          state.selectedDate.minute,
        ),
      );
    }
  }

  Future<void> pickTime(BuildContext ctx) async {
    final TimeOfDay? picked = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.fromDateTime(state.selectedDate),
    );
    if (picked != null) {
      state = state.copyWith(
        selectedDate: DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  }

  void setSendingData(bool v) => state = state.copyWith(isSendingData: v);

  /// Submits new transaction data
  Future<bool> submitNewData({int? dispatchId}) async {
    try {
      final amt = double.parse(state.amountController.text);
      final body = {
        'date':
            DateTime(
              state.selectedDate.year,
              state.selectedDate.month,
              state.selectedDate.day,
              state.selectedDate.hour,
              state.selectedDate.minute,
            ).toIso8601String(),
        'category': state.selectedCategory,
        'total_amount': amt,
        'description': state.descriptionController.text,
        'transaction_type': state.transactionType,
        'payment_method': state.selectedPaymentMethod,
        'amount': amt,
        'truck_dispatching': dispatchId,
      };

      final decodedRes = await ApiService.postRequest('api/transaction', body);
      if (decodedRes['status'] != 200) {
        debugPrint('API response error: $decodedRes');
        return false;
      }
      if (dispatchId != null) {
        return true;
      }
      final rawData = decodedRes['data'] as Map<String, dynamic>;
      ref
          .read(transactionDataProvider.notifier)
          .addTransaction(Transaction.fromJson(rawData));
      return true;
    } catch (e, stack) {
      debugPrint('Error during transaction submit: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  // save form changes
  Future<SaveStatus> saveFormChanges({
    required Transaction original,
    required bool isDispatchTransaction,
  }) async {
    try {
      var updatedData = <String, dynamic>{};

      final newDateOnly = DateTime(
        state.selectedDate.year,
        state.selectedDate.month,
        state.selectedDate.day,
      );

      final originalDateOnly = DateTime(
        original.date.year,
        original.date.month,
        original.date.day,
      );

      final originalTime = TimeOfDay.fromDateTime(original.date);
      final selectedTime = TimeOfDay.fromDateTime(state.selectedDate);

      final isDateChanged = newDateOnly != originalDateOnly;
      final isTimeChanged = selectedTime != originalTime;

      if (isDateChanged || isTimeChanged && isDispatchTransaction) {
        final newDateTime = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
          state.selectedDate.hour,
          state.selectedDate.minute,
        );
        updatedData['date'] = newDateTime.toIso8601String();
      }

      final amtText = state.amountController.text.trim();
      if (amtText.isNotEmpty) {
        final newAmt = double.tryParse(amtText);
        if (newAmt != null && newAmt != original.amount) {
          updatedData['amount'] = newAmt;
        }
      }

      if (state.transactionType != null &&
          state.transactionType != original.transactionType) {
        updatedData['transaction_type'] = state.transactionType;
      }

      if (state.selectedCategory != null &&
          state.selectedCategory != original.category) {
        updatedData['category'] = state.selectedCategory;
      }

      final newDesc = state.descriptionController.text.trim();
      if (newDesc != original.description) {
        updatedData['description'] = newDesc;
      }

      if (state.selectedPaymentMethod != null &&
          isDispatchTransaction &&
          state.selectedPaymentMethod != original.paymentMethod) {
        updatedData['payment_method'] = state.selectedPaymentMethod;
      }

      if (updatedData.isEmpty) {
        return SaveStatus.noChanges;
      }

      bool ok = true;

      ok &= await ApiService.patchRequest(
        'api/transaction/${original.id}',
        updatedData,
      );
      if (ok) {
        if (updatedData.containsKey('date')) {
          original.date = DateTime.parse(updatedData['date']);
        }
        if (updatedData.containsKey('amount')) {
          original.amount = updatedData['amount'];
        }
        if (updatedData.containsKey('transaction_type')) {
          original.transactionType = updatedData['transaction_type'];
        }
        if (updatedData.containsKey('category')) {
          original.category = updatedData['category'];
        }
        if (updatedData.containsKey('description')) {
          original.description = updatedData['description'];
        }
        if (updatedData.containsKey('payment_method')) {
          original.paymentMethod = updatedData['payment_method'];
        }
      }
      updatedData = {};
      if (ok) {
        ref.read(transactionDataProvider.notifier).updateTransaction(original);
        return SaveStatus.success;
      }
      return SaveStatus.failure;
    } catch (e) {
      return SaveStatus.failure;
    }
  }

  /// Submits new dispatch data
  Future<bool> submitNewDispatchData() async {
    try {
      final data = {
        'dispatching_date':
            DateTime(
              state.selectedDate.year,
              state.selectedDate.month,
              state.selectedDate.day,
            ).toIso8601String(),
        'truck': state.selectedTruck,
        'driver_name': state.driverNameController.text,
      };
      final result = await ApiService.postRequest('api/truck-dispatch', data);
      debugPrint(result);
      if (result == null || result['status'] != 200 || result['id'] == null) {
        debugPrint('Dispatch Data Creation failed: $result');
        return false;
      }
      final success = await submitNewData(dispatchId: result['id']);
      return success;
    } catch (e, stack) {
      debugPrint('Error in submitParentData: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  /// Saves changes to dispatch data
  Future<SaveStatus> saveDispatchDataChanges(DispatchData original) async {
    try {
      var updatedDispatchingData = <String, dynamic>{};

      final dispatchId = original.id;

      final newDateOnly = DateTime(
        state.selectedDate.year,
        state.selectedDate.month,
        state.selectedDate.day,
      );

      final originalDateOnly = DateTime(
        original.dispatchingDate!.year,
        original.dispatchingDate!.month,
        original.dispatchingDate!.day,
      );
      final isDateChanged = newDateOnly != originalDateOnly;
      if (isDateChanged) {
        final newDateTime = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
          state.selectedDate.hour,
          state.selectedDate.minute,
        );
        updatedDispatchingData['dispatching_date'] =
            newDateTime.toIso8601String();
      }

      final newDriver = state.driverNameController.text.trim();
      final oldDriver = original.driver ?? '';
      if (newDriver.isNotEmpty && newDriver != oldDriver) {
        updatedDispatchingData['driver_name'] = newDriver;
      }

      final newTruck = state.selectedTruck;
      final oldTruck = original.truck;
      if (newTruck != null && newTruck != oldTruck['id']) {
        updatedDispatchingData['truck'] = newTruck;
      }

      if (updatedDispatchingData.isEmpty) {
        return SaveStatus.noChanges;
      }

      bool ok = true;

      ok &= await ApiService.patchRequest(
        'api/truck-dispatch/$dispatchId',
        updatedDispatchingData,
      );

      if (updatedDispatchingData.containsKey('dispatching_date')) {
        original.dispatchingDate = DateTime.parse(
          updatedDispatchingData['dispatching_date'],
        );
      }
      if (updatedDispatchingData.containsKey('driver_name')) {
        original.driver = updatedDispatchingData['driver_name'];
      }
      if (updatedDispatchingData.containsKey('truck')) {
        original.truck['id'] = updatedDispatchingData['truck'];
      }

      updatedDispatchingData = {};
      if (ok) {
        ref.read(transactionDataProvider.notifier).updateDispatching(original);
        return SaveStatus.success;
      }
      return SaveStatus.failure;
    } catch (e) {
      return SaveStatus.failure;
    }
  }

  Future<bool> deleteTransactionData(int transactionId) async {
    try {
      final res = await ApiService.deleteRequest(
        'api/transaction/$transactionId',
      );
      if (!res) return res;
      ref
          .read(transactionDataProvider.notifier)
          .removeTransaction(transactionId);
      return res;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDispatchData(int dispatchId) async {
    try {
      state = state.copyWith(isSendingData: true);
      final result = await ApiService.deleteRequest(
        'api/truck-dispatch/$dispatchId',
      );
      return result;
    } catch (e) {
      return false;
    } finally {
      state = state.copyWith(isSendingData: false);
    }
  }

  Future<void> convertDispatchMode(int id, bool value) async {
    try {
      state = state.copyWith(isSendingData: true);
      final res = await ApiService.patchRequest('api/truck-dispatch/$id', {
        'is_active': value,
      });
      if (res) {
        ref
            .read(transactionDataProvider.notifier)
            .updateDispatchData(id, value);
      }
    } catch (e) {
      debugPrint('Error deactivating dispatch: $e');
    } finally {
      state = state.copyWith(isSendingData: false);
    }
  }

  Future<bool> createDispatchData(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isSendingData: true);
      final res = await ApiService.postRequest('api/truck-dispatch', data);
      if (res['status'] == 200) {
        await ref
            .read(transactionDataProvider.notifier)
            .fetchDispatchData(isReload: true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error creating dispatch data: $e');
      return false;
    } finally {
      state = state.copyWith(isSendingData: false);
    }
  }

  void resetForm() {
    debugPrint('Resetting transaction form');
    state = TransactionFormState(
      isSendingData: false,
      selectedPaymentMethod: null,
      selectedCategory: null,
      transactionType: null,
      selectedDate: DateTime.now(),
      selectedTruck: null,
      amountController: TextEditingController(),
      householdTotalTaken: TextEditingController(),
      descriptionController: TextEditingController(),
      driverNameController: TextEditingController(),
    );
  }

  @override
  void dispose() {
    state.amountController.dispose();
    state.descriptionController.dispose();
    state.driverNameController.dispose();
    super.dispose();
  }
}
