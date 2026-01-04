import 'package:flutter/material.dart';
import 'package:finager/models/account.dart';
import 'package:finager/l10n/app_localizations.dart';
import './summary_item.dart';

class HomeHeader extends StatelessWidget {
  final List<Account> accounts;
  final double fontSize;
  final double tdyIncome;
  final double tdyExpense;

  const HomeHeader({
    super.key,
    required this.accounts,
    this.fontSize = 25,
    required this.tdyIncome,
    required this.tdyExpense,
  });

  @override
  Widget build(BuildContext context) {
    final income = tdyIncome;
    final expense = tdyExpense;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(220), // dynamic background
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(80), // dynamic shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.currentBalance,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                accounts.isNotEmpty ? '${accounts[0].balance}0 Ks' : '0.00',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                accounts.isNotEmpty
                    ? "(${getAmountLabel(accounts[0].balance, context)} ${AppLocalizations.of(context)!.currencyUnit})"
                    : "0.00",
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: fontSize * 0.8,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SummaryItem(
                textColor: colorScheme.primary,
                title:
                    "${AppLocalizations.of(context)!.today} ${AppLocalizations.of(context)!.income}",
                amount: income.toStringAsFixed(2),
              ),
              SummaryItem(
                textColor: colorScheme.error,
                title:
                    "${AppLocalizations.of(context)!.today} ${AppLocalizations.of(context)!.expense} ",
                amount: expense.toStringAsFixed(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getAmountLabel(double amount, BuildContext context) {
    final int rounded = amount.round();
    return numberToWords(rounded, context);
  }

  String numberToWords(int number, BuildContext context) {
    try {
      if (number == 0) return AppLocalizations.of(context)!.zero;

      final app = AppLocalizations.of(context)!;

      final units = [
        '',
        app.one,
        app.two,
        app.three,
        app.four,
        app.five,
        app.six,
        app.seven,
        app.eight,
        app.nine,
        app.ten,
        app.eleven,
        app.twelve,
        app.thirteen,
        app.fourteen,
        app.fifteen,
        app.sixteen,
        app.seventeen,
        app.eighteen,
        app.nineteen,
      ];

      final tens = [
        '',
        '',
        app.twenty,
        app.thirty,
        app.forty,
        app.fifty,
        app.sixty,
        app.seventy,
        app.eighty,
        app.ninety,
      ];

      String convertBelowThousand(int n) {
        if (n < 20) {
          return (n >= 0 && n < units.length && units[n].isNotEmpty)
              ? units[n]
              : '';
        }
        if (n < 100) {
          return tens[n ~/ 10] + (n % 10 != 0 ? ' ${units[n % 10]}' : '');
        }
        return '${units[n ~/ 100]} ${app.hundred}${n % 100 != 0 ? ' ${convertBelowThousand(n % 100)}' : ''}';
      }

      if (app.localeName == 'my') {
        String result = '';
        if (number >= 1000000000) {
          result +=
              '${convertBelowThousand(number ~/ 1000000000)} ${app.tenThousand} ';
          number %= 1000000000;
        }
        if (number >= 100000000) {
          result +=
              '${convertBelowThousand(number ~/ 100000000)} ${app.thousand} ';
          number %= 100000000;
        }
        if (number >= 100000) {
          result += '${convertBelowThousand(number ~/ 100000)} ${app.lakh} ';
          number %= 100000;
        }
        if (number >= 10000) {
          result +=
              '${convertBelowThousand(number ~/ 10000)} ${app.tenThousand} ';
          number %= 10000;
        }
        if (number >= 1000) {
          result += '${convertBelowThousand(number ~/ 1000)} ${app.thousand} ';
          number %= 1000;
        }
        if (number > 0) {
          result += convertBelowThousand(number);
        }

        return result.trim();
      } else {
        String convertHundreds(int n) {
          if (n < 20) {
            return (n >= 0 && n < units.length && units[n].isNotEmpty)
                ? units[n]
                : '';
          }
          if (n < 100) {
            return tens[n ~/ 10] + (n % 10 != 0 ? ' ${units[n % 10]}' : '');
          }
          return '${units[n ~/ 100]} ${app.hundred}${n % 100 != 0 ? ' ${convertHundreds(n % 100)}' : ''}';
        }

        String words = '';
        if (number >= 1000000) {
          words += '${convertHundreds(number ~/ 1000000)} ${app.million}  ';
          number %= 1000000;
        }
        if (number >= 1000) {
          words += '${convertHundreds(number ~/ 1000)} ${app.thousand}  ';
          number %= 1000;
        }
        if (number > 0) {
          words += convertHundreds(number);
        }

        return words.trim();
      }
    } catch (e) {
      return "Error Impossible Value";
    }
  }
}
