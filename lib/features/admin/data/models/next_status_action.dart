import 'orders_model.dart';

// Describes one "next status" button for an order.
class NextStatusAction {
  final OrderStatus status;
  final String label;

  const NextStatusAction({required this.status, required this.label});
}
