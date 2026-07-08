import 'package:cloud_firestore/cloud_firestore.dart';

/// Parse a dynamic value to double
double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

/// Parse a dynamic value to int
int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

/// Parse a dynamic value to DateTime
DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value);
  return null;
}

/// Clean a string value (trim, handle null/empty)
String? cleanString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isNotEmpty ? text : null;
}
