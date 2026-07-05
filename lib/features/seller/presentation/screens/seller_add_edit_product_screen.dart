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
  final SellerProductModel product;

  const SellerAddEditProductScreen({super.key, required this.product});

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

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
        text: widget.product.price.toStringAsFixed(2));
    _stockController =
        TextEditingController(text: widget.product.stock.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _selectedCategory = widget.product.category;
    _images = widget.product.images.toList();
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
  bool _isLoading = false;

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

    setState(() => _isLoading = true);

    try {
      final cubit = context.read<SellerCubit>();
      final product = SellerProductModel(
        id: widget.product.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        stock: stock,
        category: _selectedCategory ?? 'Ceramics',
        images: _images.isNotEmpty ? _images : ['https://via.placeholder.com/150'],
        isActive: stock > 0,
        status: status,
      );
      await cubit.updateProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product updated successfully'),
            backgroundColor: const Color(0xff07880E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Get.back();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  void _removeImage(int index) {
    setState(() {
      final imagePath = _images[index];
      _images.removeAt(index);
      // Remove from new images list if it was a local file
      _newImages.removeWhere((file) => file.path == imagePath);
    });
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Product',
          style: TextStyle(
            color: const Color(0xFF0F172A),
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
                          color: const Color(0xFF0F172A),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SellerImageUpload(
                        images: _images,
                        onTap: _pickImage,
                        onDelete: _removeImage,
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
                              color: const Color(0xFF0F172A),
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF94A3B8),
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF0F172A),
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select category',
                              hintStyle: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF94A3B8),
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
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
                              return DropdownMenuItem<String>(
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
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFE2E8F0),
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
                            side: const BorderSide(
                              color: Color(0xFFE2E8F0),
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
                              color: const Color(0xFF64748B),
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
                          onPressed: _isLoading ? null : _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8B4513),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xff8B4513).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading 
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
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
