import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
    Locale('zh')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @household.
  ///
  /// In en, this message translates to:
  /// **'Household Record'**
  String get household;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'About Description'**
  String get aboutDescription;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addDispatching.
  ///
  /// In en, this message translates to:
  /// **'New Dispatch'**
  String get addDispatching;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @addTruckDispatching.
  ///
  /// In en, this message translates to:
  /// **'Add Truck Dispatch'**
  String get addTruckDispatching;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @saveData.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveData;

  /// No description provided for @finalBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get finalBalance;

  /// No description provided for @totalTakenAmount.
  ///
  /// In en, this message translates to:
  /// **'Taken Amount'**
  String get totalTakenAmount;

  /// No description provided for @totalTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken Amount'**
  String get totalTaken;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDate;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get chooseTime;

  /// No description provided for @currencyUnit.
  ///
  /// In en, this message translates to:
  /// **'Kyats'**
  String get currencyUnit;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get desc;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get description;

  /// No description provided for @dispatch.
  ///
  /// In en, this message translates to:
  /// **'Dispatch'**
  String get dispatch;

  /// No description provided for @dispatchDetail.
  ///
  /// In en, this message translates to:
  /// **'Dispatch Details'**
  String get dispatchDetail;

  /// No description provided for @dispatchNotFound.
  ///
  /// In en, this message translates to:
  /// **'No Dispatch Found'**
  String get dispatchNotFound;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver Name (Optional)'**
  String get driver;

  /// No description provided for @driverName.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driverName;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @eighteen.
  ///
  /// In en, this message translates to:
  /// **'Eighteen'**
  String get eighteen;

  /// No description provided for @eight.
  ///
  /// In en, this message translates to:
  /// **'Eight'**
  String get eight;

  /// No description provided for @eighty.
  ///
  /// In en, this message translates to:
  /// **'Eighty'**
  String get eighty;

  /// No description provided for @eleven.
  ///
  /// In en, this message translates to:
  /// **'Eleven'**
  String get eleven;

  /// No description provided for @expenseAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Expense Analytics'**
  String get expenseAnalytics;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// No description provided for @failedToAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Failed to Add Transaction'**
  String get failedToAddTransaction;

  /// No description provided for @failedToUpdateChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to Update Changes'**
  String get failedToUpdateChanges;

  /// No description provided for @fifteen.
  ///
  /// In en, this message translates to:
  /// **'Fifteen'**
  String get fifteen;

  /// No description provided for @fifty.
  ///
  /// In en, this message translates to:
  /// **'Fifty'**
  String get fifty;

  /// No description provided for @finalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Final Profit'**
  String get finalRevenue;

  /// No description provided for @five.
  ///
  /// In en, this message translates to:
  /// **'Five'**
  String get five;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @forty.
  ///
  /// In en, this message translates to:
  /// **'Forty'**
  String get forty;

  /// No description provided for @four.
  ///
  /// In en, this message translates to:
  /// **'Four'**
  String get four;

  /// No description provided for @fourteen.
  ///
  /// In en, this message translates to:
  /// **'Fourteen'**
  String get fourteen;

  /// No description provided for @householdExpenses.
  ///
  /// In en, this message translates to:
  /// **'Household Expenses'**
  String get householdExpenses;

  /// No description provided for @hundred.
  ///
  /// In en, this message translates to:
  /// **'Hundred'**
  String get hundred;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lakh.
  ///
  /// In en, this message translates to:
  /// **'Lakh'**
  String get lakh;

  /// No description provided for @loadingMsg.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loadingMsg;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @million.
  ///
  /// In en, this message translates to:
  /// **'Million'**
  String get million;

  /// No description provided for @nine.
  ///
  /// In en, this message translates to:
  /// **'Nine'**
  String get nine;

  /// No description provided for @nineteen.
  ///
  /// In en, this message translates to:
  /// **'Nineteen'**
  String get nineteen;

  /// No description provided for @ninety.
  ///
  /// In en, this message translates to:
  /// **'Ninety'**
  String get ninety;

  /// No description provided for @noChangesMade.
  ///
  /// In en, this message translates to:
  /// **'No Changes Made'**
  String get noChangesMade;

  /// No description provided for @noDate.
  ///
  /// In en, this message translates to:
  /// **'No Date Selected'**
  String get noDate;

  /// No description provided for @noMoreTransactions.
  ///
  /// In en, this message translates to:
  /// **'No More Transactions'**
  String get noMoreTransactions;

  /// No description provided for @noTimePicked.
  ///
  /// In en, this message translates to:
  /// **'No Time Picked'**
  String get noTimePicked;

  /// No description provided for @noTransactionFound.
  ///
  /// In en, this message translates to:
  /// **'No Transaction Found'**
  String get noTransactionFound;

  /// No description provided for @numberMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount Must Be Positive'**
  String get numberMustBePositive;

  /// No description provided for @one.
  ///
  /// In en, this message translates to:
  /// **'One'**
  String get one;

  /// No description provided for @outcome.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get outcome;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @pickedDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pickedDate;

  /// No description provided for @pickedTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get pickedTime;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please Select Category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please Select Payment Method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @pleaseSelectPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Please Select Payment Type'**
  String get pleaseSelectPaymentType;

  /// No description provided for @pleaseSelectTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Please Select Transaction Type'**
  String get pleaseSelectTransactionType;

  /// No description provided for @pleaseSelectTruckNumber.
  ///
  /// In en, this message translates to:
  /// **'Please Select Truck Number'**
  String get pleaseSelectTruckNumber;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get revenue;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @seventeen.
  ///
  /// In en, this message translates to:
  /// **'Seventeen'**
  String get seventeen;

  /// No description provided for @seven.
  ///
  /// In en, this message translates to:
  /// **'Seven'**
  String get seven;

  /// No description provided for @seventy.
  ///
  /// In en, this message translates to:
  /// **'Seventy'**
  String get seventy;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @six.
  ///
  /// In en, this message translates to:
  /// **'Six'**
  String get six;

  /// No description provided for @sixteen.
  ///
  /// In en, this message translates to:
  /// **'Sixteen'**
  String get sixteen;

  /// No description provided for @successfullyDeletedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction Deleted Successfully'**
  String get successfullyDeletedTransaction;

  /// No description provided for @successfullyUpdatedChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes Updated Successfully'**
  String get successfullyUpdatedChanges;

  /// No description provided for @ten.
  ///
  /// In en, this message translates to:
  /// **'Ten'**
  String get ten;

  /// No description provided for @tenThousand.
  ///
  /// In en, this message translates to:
  /// **'Ten Thousand'**
  String get tenThousand;

  /// No description provided for @thirteen.
  ///
  /// In en, this message translates to:
  /// **'Thirteen'**
  String get thirteen;

  /// No description provided for @thirty.
  ///
  /// In en, this message translates to:
  /// **'Thirty'**
  String get thirty;

  /// No description provided for @thisMonthDailyAverageIncome.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Daily Average Income'**
  String get thisMonthDailyAverageIncome;

  /// No description provided for @thisMonthIncome.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Income'**
  String get thisMonthIncome;

  /// No description provided for @thisMonthOutcome.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Expense'**
  String get thisMonthOutcome;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @thousand.
  ///
  /// In en, this message translates to:
  /// **'Thousand'**
  String get thousand;

  /// No description provided for @three.
  ///
  /// In en, this message translates to:
  /// **'Three'**
  String get three;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalSpent;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @transactionAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transaction Added Successfully'**
  String get transactionAddedSuccessfully;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction Not Found'**
  String get transactionNotFound;

  /// No description provided for @truck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get truck;

  /// No description provided for @truckDispatch.
  ///
  /// In en, this message translates to:
  /// **'Truck Dispatch List'**
  String get truckDispatch;

  /// No description provided for @truckExpenses.
  ///
  /// In en, this message translates to:
  /// **'Truck Expenses'**
  String get truckExpenses;

  /// No description provided for @truckNumber.
  ///
  /// In en, this message translates to:
  /// **'Truck Number'**
  String get truckNumber;

  /// No description provided for @twelve.
  ///
  /// In en, this message translates to:
  /// **'Twelve'**
  String get twelve;

  /// No description provided for @twenty.
  ///
  /// In en, this message translates to:
  /// **'Twenty'**
  String get twenty;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @viewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Detail'**
  String get viewDetail;

  /// No description provided for @weeklyAverageIncome.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average Income'**
  String get weeklyAverageIncome;

  /// No description provided for @weeklyAverageOutcome.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average Expense'**
  String get weeklyAverageOutcome;

  /// No description provided for @zero.
  ///
  /// In en, this message translates to:
  /// **'Zero'**
  String get zero;

  /// No description provided for @two.
  ///
  /// In en, this message translates to:
  /// **'Two'**
  String get two;

  /// No description provided for @sixty.
  ///
  /// In en, this message translates to:
  /// **'Sixty'**
  String get sixty;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This Field is Required'**
  String get fieldRequired;

  /// No description provided for @max8Digits.
  ///
  /// In en, this message translates to:
  /// **'Maximum 8 Digits Allowed'**
  String get max8Digits;

  /// No description provided for @max10Digits.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 Digits Allowed'**
  String get max10Digits;

  /// No description provided for @onlyDigits.
  ///
  /// In en, this message translates to:
  /// **'Only Numeric Values Allowed'**
  String get onlyDigits;

  /// No description provided for @max10Words.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 Words Allowed'**
  String get max10Words;

  /// No description provided for @max20Words.
  ///
  /// In en, this message translates to:
  /// **'Maximum 20 Words Allowed'**
  String get max20Words;

  /// No description provided for @maxCharacterReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum Character Limit Reached'**
  String get maxCharacterReached;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted Successfully'**
  String get deletedSuccessfully;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to Delete'**
  String get failedToDelete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @areYouSureToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Delete?'**
  String get areYouSureToDelete;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Logout?'**
  String get logoutConfirmation;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'View List'**
  String get viewList;

  /// No description provided for @dispatchinDeleteNotice.
  ///
  /// In en, this message translates to:
  /// **'Make sure you know what you\'re doing before deleting this.'**
  String get dispatchinDeleteNotice;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter By'**
  String get filterBy;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get apply;

  /// No description provided for @noFilterSelected.
  ///
  /// In en, this message translates to:
  /// **'Please Select Filter'**
  String get noFilterSelected;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @activeDispatch.
  ///
  /// In en, this message translates to:
  /// **'Active Dispatch'**
  String get activeDispatch;

  /// No description provided for @dispatchList.
  ///
  /// In en, this message translates to:
  /// **'Dispatch List'**
  String get dispatchList;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm to Delete Transaction'**
  String get deleteTransactionConfirmation;

  /// No description provided for @editDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editDisplayName;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get displayName;

  /// No description provided for @updateDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Update Display Name'**
  String get updateDisplayName;

  /// No description provided for @dispatchActive.
  ///
  /// In en, this message translates to:
  /// **'Active Dispatch'**
  String get dispatchActive;

  /// No description provided for @dispatchInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive Dispatch'**
  String get dispatchInactive;

  /// No description provided for @deactivateDispatch.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Dispatch'**
  String get deactivateDispatch;

  /// No description provided for @confirmInactivate.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deactivation'**
  String get confirmInactivate;

  /// No description provided for @confirmActivate.
  ///
  /// In en, this message translates to:
  /// **'Confirm Activation'**
  String get confirmActivate;

  /// No description provided for @areYouSureToInactivate.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Deactivate?'**
  String get areYouSureToInactivate;

  /// No description provided for @areYouSureToActivate.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Activate?'**
  String get areYouSureToActivate;

  /// No description provided for @modelSettings.
  ///
  /// In en, this message translates to:
  /// **'Model Settings'**
  String get modelSettings;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely and never shared with third parties. We use analytics to improve the app experience. No personal data is sold or misused. For more information, please visit our website.'**
  String get privacyPolicyContent;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @contactSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'For help or support, please contact us at:\n\nsupport@finager.app'**
  String get contactSupportMessage;

  /// No description provided for @confirmRefresh.
  ///
  /// In en, this message translates to:
  /// **'Confirm Refresh'**
  String get confirmRefresh;

  /// No description provided for @confirmRefreshMsg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to refresh all model data? This will take some time.'**
  String get confirmRefreshMsg;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @successRefreshMsg.
  ///
  /// In en, this message translates to:
  /// **'All model data refreshed successfully.'**
  String get successRefreshMsg;

  /// No description provided for @refreshTip.
  ///
  /// In en, this message translates to:
  /// **'Refresh All Model Data'**
  String get refreshTip;

  /// No description provided for @categoryDetail.
  ///
  /// In en, this message translates to:
  /// **'Category Detail'**
  String get categoryDetail;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @houseExpense.
  ///
  /// In en, this message translates to:
  /// **'House Expense'**
  String get houseExpense;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @myanmar.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get myanmar;

  /// No description provided for @errEngRequired.
  ///
  /// In en, this message translates to:
  /// **'English Category Name is required.'**
  String get errEngRequired;

  /// No description provided for @errMinTransRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one translation is required.'**
  String get errMinTransRequired;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @paymentMethodDetail.
  ///
  /// In en, this message translates to:
  /// **'Payment Method Detail'**
  String get paymentMethodDetail;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @truckDetail.
  ///
  /// In en, this message translates to:
  /// **'Truck Detail'**
  String get truckDetail;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @truckType.
  ///
  /// In en, this message translates to:
  /// **'Truck Type'**
  String get truckType;

  /// No description provided for @licenseExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'License Expiry Date'**
  String get licenseExpiryDate;

  /// No description provided for @addTruck.
  ///
  /// In en, this message translates to:
  /// **'Add Truck'**
  String get addTruck;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @errTruckModelRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Truck Number, GPS IMEI, and License Exp Date are required.'**
  String get errTruckModelRequiredFields;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'my', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'my': return AppLocalizationsMy();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
