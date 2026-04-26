import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingProducts extends StatelessWidget {
  const LoadingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SvgPicture.asset('assets/icons/loading_products.svg'),
          SvgPicture.asset('assets/icons/loading_products.svg'),
          SvgPicture.asset('assets/icons/loading_products.svg'),
        ],
      ),
    );
  }
}