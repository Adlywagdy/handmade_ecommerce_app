import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';

class SellerAddProductScreen extends StatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isActive = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(text: 'Ceramics');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: commonColor, size: 24.w),
          onPressed: () {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            }
          },
        ),
        title: Text(
          'Add Product',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF1F5F9), // Light separator
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images Section
                _buildImagesSection(),
                SizedBox(height: 24.h),

                // Product Title
                _buildLabel('Product Title'),
                _buildTextField(
                  hint: 'e.g. Hand-painted Ceramic Serving Dish',
                  controller: _titleController,
                ),
                SizedBox(height: 20.h),

                // Category and Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Category'),
                          _buildTextField(
                            hint: 'Category',
                            controller: _categoryController,
                            suffixIcon: Icon(Icons.keyboard_arrow_down,
                                color: const Color(0xFF64748B), size: 20.w),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Price (EGP)'),
                          _buildTextField(
                            hint: '450.00',
                            controller: _priceController,
                            prefixText: 'EGP',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Description
                _buildLabel('Description'),
                _buildTextField(
                  hint: 'Describe your product...',
                  controller: _descriptionController,
                  maxLines: 5,
                ),
                SizedBox(height: 24.h),

                // Active Listing Toggle
                _buildActiveListingToggle(),
                SizedBox(height: 32.h),

                // Action Buttons
                _buildActionButtons(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Images',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5F2), // Light warm beige
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '${_selectedImages.length} / 5',
                style: TextStyle(
                  color: commonColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              ..._selectedImages.map((file) => Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _buildImageCard(file),
              )),
              if (_selectedImages.length < 5)
                GestureDetector(
                  onTap: _pickImage,
                  child: _buildAddPhotoCard(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(File file) {
    return Stack(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4.w,
          right: 4.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.remove(file);
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoCard() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: const Color(0xFFD6C3B1), // Light brown matching design
        strokeWidth: 1.5,
        gap: 5.0,
        dashLength: 6.0,
        radius: 8.r,
      ),
      child: Container(
        width: 90.w,
        height: 90.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8F4), 
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: commonColor, size: 24.w),
            SizedBox(height: 6.h),
            Text(
              'ADD PHOTO',
              style: TextStyle(
                color: commonColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    Widget? suffixIcon,
    String? prefixText,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Plus Jakarta Sans',
        color: const Color(0xFF334155),
        height: 1.5,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        prefixText: prefixText != null ? '$prefixText ' : null,
        prefixStyle: TextStyle(
          color: const Color(0xFF94A3B8), 
          fontSize: 14.sp,
          fontFamily: 'Plus Jakarta Sans',
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 16.h : 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Light border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: commonColor),
        ),
      ),
    );
  }

  Widget _buildActiveListingToggle() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F2), // Soft warm beige matching card UI
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1EBE5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Listing',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Visible to customers in the marketplace',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (val) {
              setState(() {
                _isActive = val;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: commonColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<SellerCubit, SellerState>(
      listener: (context, state) {
        if (state is SellerError) {
          Get.snackbar(
            'Error',
            state.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } else if (state is SellerLoaded) {
          // Handled manually after the await call
        }
      },
      builder: (context, state) {
        if (state is SellerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImages.isEmpty) {
                      Get.snackbar('Error', 'Please add at least one product image', backgroundColor: Colors.redAccent, colorText: Colors.white);
                      return;
                    }

                    double price = double.tryParse(_priceController.text) ?? 0;
                    
                    await context.read<SellerCubit>().addProductWithImages(
                      name: _titleController.text,
                      description: _descriptionController.text,
                      price: price,
                      stock: 10, // Default stock for now
                      category: _categoryController.text,
                      imageFiles: _selectedImages,
                    );
                    
                    Get.back(); // Return to previous screen
                    Get.snackbar(
                      'Success',
                      'Product added successfully!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
                icon: Icon(Icons.save_outlined, color: Colors.white, size: 20.w),
                label: Text(
                  'Save Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: commonColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: commonColor, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Discard Changes',
                  style: TextStyle(
                    color: commonColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A custom painter to draw a dashed rounded rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashLength = 5.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = distance + dashLength;
        dashPath.addPath(metric.extractPath(distance, length), Offset.zero);
        distance = length + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
