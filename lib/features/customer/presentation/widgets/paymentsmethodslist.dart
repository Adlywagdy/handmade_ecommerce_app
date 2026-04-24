import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/cart/cart_cubit/cart_cubit.dart';

class PaymentsMethodsList extends StatefulWidget {
  const PaymentsMethodsList({super.key});

  @override
  State<PaymentsMethodsList> createState() => _PaymentsMethodsListState();
}

class _PaymentsMethodsListState extends State<PaymentsMethodsList> {
  late final TextEditingController _walletPhoneController;

  @override
  void initState() {
    super.initState();
    _walletPhoneController = TextEditingController(
      text: BlocProvider.of<CartCubit>(
        context,
        listen: false,
      ).walletPhonenumber,
    );
  }

  @override
  void dispose() {
    _walletPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = BlocProvider.of<CartCubit>(context);

    return Column(
      spacing: 12.h,
      children: List.generate(_paymentListData.length, (index) {
        final paymentMethod = _paymentListData[index]["paymentMethod"]!;
        final imagePath = _paymentListData[index]["image"]!;
        final isSelected = cartCubit.selectedPaymentMethod == paymentMethod;
        final isWallet = paymentMethod == "Mobile Wallets";

        return InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            setState(() {
              cartCubit.selectedPaymentMethod = paymentMethod;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? commonColor.withValues(alpha: .8)
                    : commonColor.withValues(alpha: .15),
              ),
            ),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: commonColor,
                      size: 24.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(paymentMethod, style: AppTextStyles.t_14w500),
                    ),
                    Image.asset(
                      imagePath,
                      fit: BoxFit.fill,
                      height: 30.r,
                      width: 30.r,
                    ),
                  ],
                ),
                if (isWallet && isSelected)
                  TextFormField(
                    controller: _walletPhoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: commonColor,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    onChanged: (value) {
                      cartCubit.walletPhonenumber = value;
                    },
                    style: AppTextStyles.t_14w500,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: commonColor,
                        size: 20.r,
                      ),
                      hintText: 'Enter wallet phone (e.g. +201xxxxxxxxx)',
                      hintStyle: AppTextStyles.t_12w400.copyWith(
                        color: subTitleColor,
                      ),
                      filled: true,
                      fillColor: customerbackGroundColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: commonColor.withValues(alpha: .25),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: commonColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

final List<Map<String, String>> _paymentListData = [
  {"paymentMethod": "Visa", "image": "assets/images/visa.png"},
  {"paymentMethod": "PayPal", "image": "assets/images/paypal.png"},
  {
    "paymentMethod": "Mobile Wallets",
    "image": "assets/images/mobile_wallet.png",
  },
];
