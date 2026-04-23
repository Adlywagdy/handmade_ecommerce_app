import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../cubit/admin_cubit.dart';

/// Opens a dialog that lets an admin edit the platform commission rate.
/// Shows a spinner on Save while the Firestore write is in flight.
Future<void> showCommissionEditor(
  BuildContext context,
  double currentRate,
) {
  final cubit = context.read<AdminCubit>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _CommissionEditorDialog(currentRate: currentRate),
    ),
  );
}

class _CommissionEditorDialog extends StatefulWidget {
  final double currentRate;

  const _CommissionEditorDialog({required this.currentRate});

  @override
  State<_CommissionEditorDialog> createState() =>
      _CommissionEditorDialogState();
}

class _CommissionEditorDialogState extends State<_CommissionEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: (widget.currentRate * 100).toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final saving = context.read<AdminCubit>().savingCommission;
        return AlertDialog(
          title: const Text('Platform Commission'),
          content: TextField(
            controller: _controller,
            enabled: !saving,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              suffixText: '%',
              hintText: 'e.g. 15',
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: saving ? null : () => _save(context),
              child: saving
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(commonColor),
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null || parsed < 0 || parsed > 100) return;
    final navigator = Navigator.of(context);
    await context.read<AdminCubit>().setCommissionRate(parsed / 100);
    if (mounted) navigator.pop();
  }
}
