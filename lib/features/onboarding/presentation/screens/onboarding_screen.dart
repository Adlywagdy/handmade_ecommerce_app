import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/onboarding/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Skip',
              style: TextStyle(
                color: Color(0xff8B7A6F),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 150),
            Image.asset('assets/icons/onboarding/icon_$count.png', height: 130),
            SizedBox(height: 20),
            SizedBox(
              width: 305,
              child: Text(
                textAlign: TextAlign.center,
                OnboardingTitleDescription.titles[count - 1],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 312,
              child: Text(
                textAlign: TextAlign.center,
                OnboardingTitleDescription.subTitle[count - 1],
                style: TextStyle(fontSize: 16, color: Color(0xff8B7A6F)),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 80,
              child: Image.asset(
                'assets/icons/onboarding/onboarding_icon_$count.png',
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                if (count < 3) count++;
                setState(() {});
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: commonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      count < 3 ? 'Next' : 'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    if (count < 3)
                      Icon(Icons.navigate_next, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
