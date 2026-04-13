import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customfeaturerow.dart';

class AddressColumn extends StatefulWidget {
  const AddressColumn({super.key});

  @override
  State<AddressColumn> createState() => _AddressColumnState();
}

class _AddressColumnState extends State<AddressColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        CustomFeatureRow(
          title: 'Delivery Address',
          buttontext:
              BlocProvider.of<CustomerCubit>(context).customerData.address !=
                  null
              ? 'Change'
              : 'Add',
          onTap: () => _openAddressBottomSheet(context),
          buttontextstyle: AppTextStyles.t_16w600.copyWith(color: commonColor),
        ),
        Card(
          color: commonColor.withValues(alpha: .05),
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(
              color: commonColor.withValues(alpha: .1),
              width: 1.5,
            ),
          ),
          child: BlocBuilder<CustomerCubit, CustomerState>(
            buildWhen: (previous, current) {
              return current is GetCustomerdataSuccessedstate ||
                  current is GetCustomerdataLoadingstate ||
                  current is GetCustomerdataFailedstate ||
                  current is CustomerInitial ||
                  current is AddorUpdateCustomeraddressFailedstate ||
                  current is AddorUpdateCustomeraddressLoadingstate ||
                  current is AddorUpdateCustomeraddressSuccessedstate;
            },
            builder: (context, state) {
              if (state is AddorUpdateCustomeraddressLoadingstate) {
                return Padding(
                  padding: const EdgeInsets.all(16.0).h,
                  child: const Center(
                    child: CircularProgressIndicator(color: commonColor),
                  ),
                );
              }

              if (state is AddorUpdateCustomeraddressFailedstate) {
                return Center(child: Text(state.errorMessage));
              }

              return ListTile(
                leading: Card(
                  color: Colors.white,

                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(24.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.h,
                      right: 12,
                      left: 12,
                      top: 10.h,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: commonColor,
                      size: 26.r,
                    ),
                  ),
                ),
                title: Text(
                  BlocProvider.of<CustomerCubit>(
                        context,
                      ).customerData.address?.addresstitle ??
                      "Home",
                  style: AppTextStyles.t_16w600.copyWith(color: blackDegree),
                ),
                subtitle: Text(
                  BlocProvider.of<CustomerCubit>(
                        context,
                      ).customerData.address?.addressdescription ??
                      "123 Main St, City, Country",
                  style: AppTextStyles.t_14w400.copyWith(
                    color: blackDegree.withValues(alpha: .7),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _openAddressBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _AddressInputBottomSheet(
        initialAddress: BlocProvider.of<CustomerCubit>(
          context,
        ).customerData.address,
      );
    },
  );
}

class _AddressInputBottomSheet extends StatefulWidget {
  final AddressModel? initialAddress;
  const _AddressInputBottomSheet({required this.initialAddress});

  @override
  State<_AddressInputBottomSheet> createState() =>
      _AddressInputBottomSheetState();
}

class _AddressInputBottomSheetState extends State<_AddressInputBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _city;
  late final TextEditingController _country;
  late final TextEditingController _zip;

  @override
  void initState() {
    super.initState();
    final addr = widget.initialAddress;
    _title = TextEditingController(text: addr?.addresstitle ?? '');
    _description = TextEditingController(text: addr?.addressdescription ?? '');
    _city = TextEditingController(text: addr?.city ?? '');
    _country = TextEditingController(text: addr?.country ?? '');
    _zip = TextEditingController(text: addr?.zipCode.toString() ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _city.dispose();
    _country.dispose();
    _zip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Delivery Address',
                    style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
                  ),
                  SizedBox(height: 14.h),
                  AddressTextField(
                    controller: _title,
                    label: 'Title',
                    hint: 'Home / Work',
                  ),
                  SizedBox(height: 12.h),
                  AddressTextField(
                    controller: _description,
                    label: 'Address',
                    hint: 'Street, building',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    required: true,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: AddressTextField(
                          controller: _city,
                          label: 'City',
                          hint: 'Cairo',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AddressTextField(
                          controller: _country,
                          label: 'Country',
                          hint: 'Egypt',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  AddressTextField(
                    controller: _zip,
                    label: 'ZIP Code',
                    hint: '12345',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.zipCodeValid() != true) {
                        return 'Please enter a valid ZIP code';
                      }
                      return null;
                    },
                    required: true,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: commonColor,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() != true) return;
                        final addressData = AddressModel(
                          addresstitle: _title.text.trim().isEmpty
                              ? null
                              : _title.text.trim(),
                          addressdescription: _description.text.trim(),
                          city: _city.text.trim().isEmpty
                              ? null
                              : _city.text.trim(),
                          country: _country.text.trim().isEmpty
                              ? null
                              : _country.text.trim(),
                          zipCode: int.tryParse(_zip.text.trim()) ?? 0,
                        );
                        BlocProvider.of<CustomerCubit>(
                          context,
                        ).addorupdateCustomeraddress(addressData);
                        Get.close(1);
                      },
                      child: Text(
                        'Save Address',
                        style: AppTextStyles.t_16w600.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool required;

  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  const AddressTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.maxLines = 1,
    this.required = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      cursorColor: commonColor,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.t_14w500.copyWith(color: blackDegree),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffF9F8F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: commonColor.withValues(alpha: .1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: commonColor.withValues(alpha: .1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: commonColor.withValues(alpha: .4)),
        ),
      ),
    );
  }
}
