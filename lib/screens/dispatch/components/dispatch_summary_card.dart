import 'package:finager/components/description_field.dart';
import 'package:finager/components/driver_field.dart';
import 'package:finager/components/truck_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

final detailEditingProvider = StateProvider<bool>((ref) => false);

const kSummaryTextColor = Colors.white;
const kIncomeColor = Colors.greenAccent;
const kExpenseColor = Colors.orangeAccent;
const kRevenuePositiveColor = Colors.green;
const kRevenueNegativeColor = Colors.red;
const kBackgroundColor = Colors.transparent;

class DetailSummary extends ConsumerStatefulWidget {
  final int id;
  final DateTime? date;
  final String? driver;
  final String? description;
  final Map<String, dynamic>? truck;
  final double? income;
  final double? cost;
  final bool isHouseForm;

  const DetailSummary({
    super.key,
    required this.id,
    required this.date,
    required this.income,
    required this.cost,
    required this.isHouseForm,
    this.driver,
    this.description,
    this.truck,
  });

  @override
  ConsumerState<DetailSummary> createState() => _DetailSummaryState();
}

class _DetailSummaryState extends ConsumerState<DetailSummary> {
  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final isEditing = ref.watch(detailEditingProvider);
    final revenue = (widget.income ?? 0) - (widget.cost ?? 0);
    final isNegative = revenue < 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Container(
          color: kBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(context, appLocal, isWide, isEditing),
              const SizedBox(height: 10),
              _summaryRow(appLocal, revenue, isNegative, isWide),
              const SizedBox(height: 12),
              _infoRow(appLocal, isEditing, isWide),
            ],
          ),
        );
      },
    );
  }

  Widget _topRow(
    BuildContext context,
    AppLocalizations appLocal,
    bool isWide,
    bool isEditing,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!widget.isHouseForm)
          isEditing
              ? SizedBox(
                width: isWide ? 280 : 170,
                child: TruckDropdown(initialTruck: widget.truck),
              )
              : Text(
                '${appLocal.truck}: ${widget.truck?['name'] ?? appLocal.unknown}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kSummaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
        Text(
          widget.date != null
              ? "${appLocal.date}: ${widget.date!.day}/${widget.date!.month}/${widget.date!.year}"
              : appLocal.noDate,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: kSummaryTextColor.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    AppLocalizations appLocal,
    double revenue,
    bool isNegative,
    bool isWide,
  ) {
    final colorRevenue = isNegative ? kIncomeColor : kExpenseColor;

    final amounts = [
      _amountBox(appLocal.income, widget.income ?? 0, kIncomeColor),
      _amountBox(appLocal.expense, widget.cost ?? 0, kExpenseColor),
      _amountBox(appLocal.revenue, revenue, colorRevenue),
    ];

    return isWide
        ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: amounts,
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              amounts
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: e,
                    ),
                  )
                  .toList(),
        );
  }

  Widget _amountBox(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color.withAlpha(220),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${value.toStringAsFixed(0)} Ks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(AppLocalizations appLocal, bool isEditing, bool isWide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child:
              widget.isHouseForm
                  ? isEditing
                      ? DescriptionField(initialDescription: widget.description)
                      : Text(
                        "${appLocal.desc}: ${widget.description ?? appLocal.unknown}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      )
                  : isEditing
                  ? DriverField(initialDriver: widget.driver)
                  : Text(
                    "${appLocal.driverName}: ${widget.driver ?? appLocal.unknown}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor:
                isEditing ? Colors.red.shade300 : Colors.yellow.shade200,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          onPressed: () {
            ref.read(detailEditingProvider.notifier).state = !isEditing;
          },
          icon: Icon(isEditing ? Icons.close : Icons.edit, size: 16),
          label: Text(isEditing ? appLocal.cancel : appLocal.edit),
        ),
      ],
    );
  }
}
