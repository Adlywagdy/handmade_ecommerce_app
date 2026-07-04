import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset('assets/icons/no_internet_connection.svg'),
            SizedBox(height: 35),
            Text(
              context.l10n.noInternetConnection,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              context.l10n.offlineMessage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff64748B),
              ),
              textAlign: .center,
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {},
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: commonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.refresh_sharp, color: Colors.white),
                    Text(
                      context.l10n.retryConnection,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Plus Jakarta Sans',
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
