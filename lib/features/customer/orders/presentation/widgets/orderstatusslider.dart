import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/widgets/orderitem.dart';

class OrderStatusSlider extends StatelessWidget {
  const OrderStatusSlider({super.key, required this.orderstatus});

  final OrderStatus orderstatus;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length, (progressindex) {
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color:
                      orderstatus != _steps[progressindex] &&
                          _steps.indexWhere((step) => step == orderstatus) <=
                              progressindex
                      ? commonColor.withValues(alpha: .2)
                      : commonColor,
                  thickness: 2.h,
                ),
              ),
              Column(
                spacing: 8.h,
                mainAxisSize: .min,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor:
                        orderstatus != _steps[progressindex] &&
                            _steps.indexWhere((step) => step == orderstatus) <=
                                progressindex
                        ? commonColor.withValues(alpha: .2)
                        : commonColor,
                    child: Icon(
                      getStatusIcon(_steps[progressindex]),
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  Text(
                    _steps[progressindex]
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase(),
                    style: AppTextStyles.t_10w700.copyWith(
                      color:
                          orderstatus != _steps[progressindex] &&
                              _steps.indexWhere(
                                    (step) => step == orderstatus,
                                  ) <=
                                  progressindex
                          ? commonColor.withValues(alpha: .2)
                          : commonColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Divider(
                  color:
                      orderstatus != _steps[progressindex] &&
                          _steps.indexWhere((step) => step == orderstatus) <=
                              progressindex
                      ? commonColor.withValues(alpha: .2)
                      : commonColor,
                  thickness: 2.h,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

final List<OrderStatus> _steps = [
  OrderStatus.pending,
  OrderStatus.confirmed,
  OrderStatus.preparing,
  OrderStatus.shipped,
  OrderStatus.delivered,
];
