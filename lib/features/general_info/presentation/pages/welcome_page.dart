import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with dark overlay
          _buildBackground(),
          _buildHexagonDecorations(),
          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: AppSpacing.xxl.h * 4),
                  _buildLogo(),
                  SizedBox(height: AppSpacing.xxl.h * 2),
                  _buildStartButton(context),

                  SizedBox(height: AppSpacing.xxl.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.6),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildHexagonDecorations() {
    return Stack(
      children: [
        // Top hexagon decoration
        Positioned(
          top: 40.h,
          right: 20.w,
          child: Image.asset(
            'assets/images/Hex_1.png',
            fit: BoxFit.contain,
            color: AppColors.primary,
          ),
        ),

        // Bottom hexagon decoration
        Positioned(
          bottom: 40.h,
          left: 20.w,
          child: Image.asset('assets/images/Hex_2.png', fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/LOGO_HORIZONTAL.png',
      fit: BoxFit.contain,
      color: AppColors.secondary,
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return PrimaryButton(
      text: 'COMENZAR',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }
}
