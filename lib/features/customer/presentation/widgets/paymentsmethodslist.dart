import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';

class PaymentsMethodsList extends StatefulWidget {
  const PaymentsMethodsList({super.key});
  @override
  State<PaymentsMethodsList> createState() => _PaymentsMethodsListState();
}

class _PaymentsMethodsListState extends State<PaymentsMethodsList> {
  int selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: List.generate(_paymentListdata.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedindex = index;
              BlocProvider.of<CartCubit>(context).selectedPaymentMethod =
                  _paymentListdata[index]["paymentMethod"]!;
            });
          },
          child: Row(
            spacing: 12.w,
            children: [
              Icon(
                index == selectedindex
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: commonColor,
                size: 24.r,
              ),
              Text(
                _paymentListdata[index]["paymentMethod"]!,
                style: AppTextStyles.t_14w500,
              ),
              Image.asset(
                _paymentListdata[index]["image"]!,
                fit: BoxFit.fill,
                height: 30.r,
                width: 30.r,
              ),
            ],
          ),
        );
      }),
    );
  }
}

List<Map<String, String>> _paymentListdata = [
  {"paymentMethod": "Credit Card", "image": "assets/images/visa.png"},
  {"paymentMethod": "PayPal", "image": "assets/images/paypal.png"},
  {
    "paymentMethod": "Mobile Wallets",
    "image": "assets/images/mobile_wallet.png",
  },
];
