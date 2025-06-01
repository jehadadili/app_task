import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreenWidgets extends StatelessWidget {
  const SplashScreenWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3B82F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200.h),
            Image.asset("assets/logo_image.png", width: 120, height: 120),

            Text(
              'Framework',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),

            Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                '© 2024 Framework',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
