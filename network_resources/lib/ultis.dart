part of 'network_resources.dart';

String currencyFormatted(num? amount, {decimalDigits}) {
  return NumberFormat.currency(
    locale: 'hu_HU',
    symbol: appPrefs.currencySymbol,
    decimalDigits: decimalDigits ?? 0,
  ).format(amount ?? 0);
}

double currencyFromEditController(TextEditingController controller) {
  final cleanedText = controller.text.replaceAll(RegExp(r'[^\d.]'), '');
  if (cleanedText.isNotEmpty) {
    final amount = double.tryParse(cleanedText) ?? 0;
    return amount;
  }
  return 0;
}
