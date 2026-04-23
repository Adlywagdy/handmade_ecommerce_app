import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../cubit/seller_cubit.dart';
import '../../models/seller_model.dart';
import '../../models/data/seller_mock_data.dart';
import '../widgets/seller_input_field.dart';
import '../widgets/seller_image_upload.dart';

class SellerAddEditProductScreen extends StatefulWidget {
  final SellerProductModel? product;

  const SellerAddEditProductScreen({super.key, this.product});

  @override
  State<SellerAddEditProductScreen> createState() =>
      _SellerAddEditProductScreenState();
}

class _SellerAddEditProductScreenState
    extends State<SellerAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  String? _selectedCategory;
  late List<String> _images;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
        text: widget.product?.price.toStringAsFixed(2) ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _selectedCategory = widget.product?.category;
    _images = widget.product?.images.toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final List<File> _newImages = [];

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final stock = int.tryParse(_stockController.text) ?? 0;
    String status;
    if (stock == 0) {
      status = 'Out of Stock';
    } else if (stock <= 5) {
      status = 'Low Stock';
    } else {
      status = 'In Stock';
    }

    final cubit = context.read<SellerCubit>();
    if (_isEditing) {
      final product = SellerProductModel(
        id: widget.product!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        stock: stock,
        category: _selectedCategory ?? 'Ceramics',
        images: _images.isNotEmpty ? _images : ['https://via.placeholder.com/150'],
        isActive: stock > 0,
        status: status,
      );
      cubit.updateProduct(product);
    } else {
      if (_newImages.isEmpty) {
        Get.snackbar('Error', 'Please add at least one image',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
      await cubit.addProductWithImages(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        stock: stock,
        category: _selectedCategory ?? 'Ceramics',
        imageFiles: _newImages,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Product updated successfully'
              : 'Product added successfully',
        ),
        backgroundColor: const Color(0xff07880E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Get.back();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
        // We add it to _images so the UI updates
        _images.add(pickedFile.path); 
      });
    }
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
          onPressed: () => Get.back(),
        ),
        title: Text(
          _isEditing ? 'Edit Product' : 'Add Product',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Images
                      Text(
                        'Product Images',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SellerImageUpload(
                        images: _images,
                        onTap: _pickImage,
                      ),
                      SizedBox(height: 24.h),

                      // Product Name
                      SellerInputField(
                        label: 'Product Name',
                        hintText: 'Enter product name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Product name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Price and Stock
                      Row(
                        children: [
                          Expanded(
                            child: SellerInputField(
                              label: 'Price (\$)',
                              hintText: '0.00',
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Price is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid price';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: SellerInputField(
                              label: 'Stock',
                              hintText: '0',
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Stock is required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
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
                              hintText: 'Select category',
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
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                            items: sellerCategories.map((cat) {
                              return DropdownMenuItem(
                                  value: cat, child: Text(cat));
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
                        hintText: 'Describe your product...',
                        controller: _descriptionController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Discard button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Discard',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Save button
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8B4513),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Product',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
