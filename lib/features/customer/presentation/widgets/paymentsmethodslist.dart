import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

class PaymentsMethodsList extends StatefulWidget {
  const PaymentsMethodsList({super.key});
  @override
  State<PaymentsMethodsList> createState() => _PaymentsMethodsListState();
}

int selectedindex = 0;

class _PaymentsMethodsListState extends State<PaymentsMethodsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: List.generate(_paymentListdata.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedindex = index;
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
              Text(_paymentListdata[index].paymentMethod!),
              Image.asset(
                _paymentListdata[index].image!,
                fit: BoxFit.fill,
                height: 30.h,
                width: 30.w,
              ),
            ],
          ),
        );
      }),
    );
  }
}

List<PaymentDetailsModel> _paymentListdata = [
  PaymentDetailsModel(
    paymentMethod: "Credit Card",
    image: "assets/images/visa.png",
  ),
  PaymentDetailsModel(
    paymentMethod: "PayPal",
    image: "assets/images/paypal.png",
  ),
  PaymentDetailsModel(
    paymentMethod: "Mobile Wallets",
    image: "assets/images/mobile_wallet.png",
  ),
  PaymentDetailsModel(paymentMethod: "COD", image: "assets/images/COD.png"),
];
