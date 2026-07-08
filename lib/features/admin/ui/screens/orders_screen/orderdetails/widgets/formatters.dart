// Turns a number into a readable price string, e.g. "EGP 120.00".
String formatMoney(double value, String currency) {
  return '$currency ${value.toStringAsFixed(2)}';
}

// Turns a DateTime into "YYYY-MM-DD", or "—" if the date is null.
String formatDate(DateTime? date) {
  if (date == null) return '—';
  final String year = date.year.toString();
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
