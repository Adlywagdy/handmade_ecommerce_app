import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/cubit/admin_cubit.dart';
import 'package:handmade_ecommerce_app/features/admin/models/next_status_action.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';
import 'no_more_actions.dart';
import 'status_action_button.dart';

// buttons to manage order status [pending ,confirmed, preparing, shipped, delivered, cancelled]
/// if pending can be (confirmed or cancelled)
/// if shipped can be (delivered)
/// if delivered can be (cancelled)
class StatusActionsButtons extends StatefulWidget {
  final OrderModel order;
  final AdminCubit cubit;
  final bool isBusy;

  const StatusActionsButtons({
    super.key,
    required this.order,
    required this.cubit,
    required this.isBusy,
  });

  @override
  State<StatusActionsButtons> createState() => _StatusActionsButtonsState();
}

class _StatusActionsButtonsState extends State<StatusActionsButtons> {
  // to store last status the user tapped
  OrderStatus? _lastStatus;

  void _onButtonPressed(OrderStatus tappedStatus) {
    setState(() {
      _lastStatus = tappedStatus;
    });
    widget.cubit.updateOrderStatus(widget.order, tappedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final List<NextStatusAction> actions = widget.cubit.nextOrderActions(
      widget.order.status,
    );

    if (actions.isEmpty) {
      return NoMoreActions(status: widget.order.status);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update status',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: blackDegree,
          ),
        ),
        SizedBox(height: 10.h),
        // One button for each allowed next status.
        for (final action in actions) _buildStatusButton(action),
      ],
    );
  }

  Widget _buildStatusButton(NextStatusAction action) {
    return StatusActionButton(
      nextStatus: action.status,
      label: action.label,
      isLoading: widget.isBusy && _lastStatus == action.status,
      isEnabled: !widget.isBusy,
      onPressed: () => _onButtonPressed(action.status),
    );
  }
}
