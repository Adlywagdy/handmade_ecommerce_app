import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternetConnection extends StatefulWidget {
  const NoInternetConnection({super.key});

  @override
  State<NoInternetConnection> createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset('assets/icons/no_internet_connection.svg'),
            SizedBox(height: height * 0.05),
            Text(
              'No internet connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              "It looks like you're offline. Please check your\nnetwork settings and try again.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff64748B),
              ),
              textAlign: .center,
            ),
            SizedBox(height: height * 0.1),
            InkWell(
              onTap: () {},
              child: Container(
                height: height * 0.06,
                width: width * 0.55,
                decoration: BoxDecoration(
                  color: Color(0xff8B4513),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.refresh_sharp, color: Colors.white),
                    Text(
                      ' Retry Connection',
                      style: TextStyle(
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
