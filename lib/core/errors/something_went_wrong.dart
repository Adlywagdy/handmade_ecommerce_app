import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SomethingWentWrong extends StatefulWidget {
  const SomethingWentWrong({super.key});

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
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
            SvgPicture.asset('assets/icons/something_went_wrong.svg'),
            SizedBox(height: height * 0.05),
            Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              "We're experiencing technical difficulties on our end.\nOur team is working on it.",
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
                width: width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff8B4513)),
                ),
                child: Center(
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8B4513),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
