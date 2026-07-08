import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../logic/seller_cubit.dart';
import '../../data/models/seller_model.dart';
import '../../data/models/data/seller_mock_data.dart';
import '../widgets/seller_input_field.dart';
import '../widgets/seller_image_upload.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

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
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
    _stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
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
      status = context.l10n.selOutOfStock;
    } else if (stock <= 5) {
      status = context.l10n.selLowStock;
    } else {
      status = context.l10n.selInStock;
    }

    setState(() => _isLoading = true);

    try {
      final cubit = context.read<SellerCubit>();

      final existingImageUrls = _images
          .where((img) => img.startsWith('http'))
          .toList();

      final product = SellerProductModel(
        id: widget.product.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        stock: stock,
        category: _selectedCategory ?? 'Ceramics',
        images: widget.product.images,
        isActive: stock > 0,
        status: status,
      );

      await cubit.updateProductWithImages(
        product: product,
        newImageFiles: _newImages,
        existingImageUrls: existingImageUrls,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.selProductUpdatedSuccessfully),
            backgroundColor: const Color(0xff07880E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Get.back();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.selErrorSavingProduct(e.toString())),
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
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
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
          context.l10n.selEditProduct,
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Images
                      Text(
                        context.l10n.selProductImages,
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
                        label: context.l10n.productName,
                        hintText: context.l10n.enterProductName,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.productNameIsRequired;
                          }
                          if (value.trim().length < 3) {
                            return context.l10n.selNameMin3Chars;
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
                              label: context.l10n.price,
                              hintText: '0.00',
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return context.l10n.selPriceRequired;
                                }
                                final parsed = double.tryParse(value);
                                if (parsed == null) {
                                  return context.l10n.selInvalidPrice;
                                }
                                if (parsed < 0) {
                                  return context.l10n.selPriceCannotBeNegative;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: SellerInputField(
                              label: context.l10n.stock,
                              hintText: '0',
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return context.l10n.selStockRequired;
                                }
                                final parsed = int.tryParse(value);
                                if (parsed == null) {
                                  return context.l10n.selInvalidNumber;
                                }
                                if (parsed < 0) {
                                  return context.l10n.selStockCannotBeNegative;
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
                            context.l10n.category,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
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
                              hintText: context.l10n.selSelectCategory,
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
                                return context.l10n.selPleaseSelectCategory;
                              }
                              return null;
                            },
                            items: sellerCategories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
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
                        label: context.l10n.description,
                        hintText: context.l10n.describeYourProduct,
                        controller: _descriptionController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.selDescriptionRequired;
                          }
                          if (value.trim().length < 10) {
                            return context.l10n.selDescriptionMin10Chars;
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
                border: Border(top: BorderSide(color: const Color(0xFFE2E8F0))),
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
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            context.l10n.selDiscard,
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
                            disabledBackgroundColor: const Color(
                              0xff8B4513,
                            ).withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  context.l10n.selSaveProduct,
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
