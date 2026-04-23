import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/core/models/image_picker_helper.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:image_picker/image_picker.dart';

class CustomProfilePicture extends StatefulWidget {
  const CustomProfilePicture({super.key, required this.customer});

  final CustomerModel customer;

  @override
  State<CustomProfilePicture> createState() => _CustomProfilePictureState();
}

class _CustomProfilePictureState extends State<CustomProfilePicture> {
  XFile? _selectedImage;
  Uint8List? _webImageBytes;

  @override
  void initState() {
    super.initState();
    _recoverLostData();
  }

  Future<void> _recoverLostData() async {
    final LostDataResponse response = await imagePickerHelper.recoverLostData();
    if (response.isEmpty) return;

    final XFile? recoveredFile = response.files?.isNotEmpty == true
        ? response.files!.first
        : null;

    if (recoveredFile != null) {
      await _setSelectedImage(recoveredFile);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.exception?.message ?? 'Failed to recover image.',
        ),
        backgroundColor: redDegree,
      ),
    );
  }

  Future<void> _setSelectedImage(XFile image) async {
    final Uint8List? bytes = kIsWeb
        ? await imagePickerHelper.xFileToBytes(image)
        : null;

    if (!mounted) return;
    setState(() {
      _selectedImage = image;
      _webImageBytes = bytes;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await imagePickerHelper.pickImageFromGallery();
      if (pickedImage == null) return;

      await _setSelectedImage(pickedImage);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Image picker is unavailable now. Restart the app and try again.',
          ),
        ),
      );
    }
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      if (kIsWeb && _webImageBytes != null) {
        return ClipOval(
          child: Image.memory(
            _webImageBytes!,
            fit: BoxFit.cover,
            width: 150.r,
            height: 150.r,
          ),
        );
      }

      if (!kIsWeb) {
        return ClipOval(
          child: Image.file(
            File(_selectedImage!.path),
            fit: BoxFit.cover,
            width: 150.r,
            height: 150.r,
          ),
        );
      }
    }

    final String? imagePath = widget.customer.image;

    if (imagePath == null || imagePath.endsWith('.svg')) {
      return SvgPicture.asset(
        'assets/images/unknown_user_icon.svg',
        width: 100.r,
        height: 100.r,
        fit: BoxFit.cover,
      );
    }

    final ImageProvider<Object> imageProvider =
        imagePath.startsWith('http://') || imagePath.startsWith('https://')
        ? NetworkImage(imagePath)
        : AssetImage(imagePath);

    return Image(
      image: imageProvider,
      fit: BoxFit.cover,
      width: 150.r,
      height: 150.r,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 81.r,
          backgroundColor: commonColor.withValues(alpha: .15),
          child: CircleAvatar(
            radius: 80.r,
            backgroundColor: Colors.white.withValues(alpha: .5),
            child: CircleAvatar(
              radius: 75.r,
              backgroundColor: Colors.white,
              child: _buildProfileImage(),
            ),
          ),
        ),
        Positioned(
          bottom: 0.h,
          right: 0.h,
          child: CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
            child: CustomIconButton(
              onPressed: _pickImage,
              backgroundColor: commonColor,
              icon: Icons.camera_alt_outlined,
              iconcolor: Colors.white,
              iconsize: 20.r,
            ),
          ),
        ),
      ],
    );
  }
}
