import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/seller_input_field.dart';
import '../widgets/seller_image_upload.dart';
import '../../models/data/seller_mock_data.dart';

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({super.key});

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _agreedToTerms = false;
  final List<String> _uploadedImages = [];

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the Terms of Service'),
          backgroundColor: const Color(0xffD32F2F),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Mock submission
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Request Submitted!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          'Your seller registration request has been submitted successfully. We will review your application and get back to you soon.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: const Color(0xff8B4513),
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mockImageUpload() {
    setState(() {
      if (_uploadedImages.length < 3) {
        _uploadedImages.add('assets/images/splash.jpeg');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Become a Seller',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff8B4513), Color(0xffA0522D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Start Selling Your\nHandmade Creations',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Plus Jakarta Sans',
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Join our community of artisans',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                // Store Name field
                SellerInputField(
                  label: 'Store Name',
                  hintText: 'Enter your store name',
                  controller: _storeNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Store name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Store name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Category dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      dropdownColor: const Color(0xFF16213E),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Select a category',
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withValues(alpha: 0.3),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                        filled: true,
                        fillColor: const Color(0xFF16213E),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xff8B4513),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xffD32F2F),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) return 'Please select a category';
                        return null;
                      },
                      items: sellerCategories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedCategory = val);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Description
                SellerInputField(
                  label: 'Description',
                  hintText: 'Tell us about your store and products...',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    if (value.trim().length < 20) {
                      return 'Description must be at least 20 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Image Upload
                Text(
                  'Store Logo / Cover Image',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                SizedBox(height: 8.h),
                SellerImageUpload(
                  images: _uploadedImages,
                  onTap: _mockImageUpload,
                ),
                SizedBox(height: 24.h),

                // Terms of Service
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (val) {
                          setState(() => _agreedToTerms = val ?? false);
                        },
                        activeColor: const Color(0xff8B4513),
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _agreedToTerms = !_agreedToTerms),
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                            children: [
                              TextSpan(
                                text: 'Seller Terms of Service',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xff8B4513),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Plus Jakarta Sans',
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xff8B4513),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8B4513),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
