import 'dart:developer';

import 'package:booster/core/services/api_key_service.dart';
import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/core/widgets/outline_button.dart';
import 'package:booster/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:booster/features/auth/presentation/bloc/auth_event.dart';
import 'package:booster/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  void _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }
  void _handleLogout() {
    context.read<AuthBloc>().add(SignOutRequested());
  }
  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras se inicializa
    if (sharedPreferences == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {

              log('${ApiKeyService(sharedPreferences!).getApiKey()}');
              final userName =
                  state is Authenticated ? state.user.name : 'Usuario';

              return AppHeader(
                showDecoration: true,
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/svg/back.svg'),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Bienvenido $userName',
                    style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                trailing: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/profile');
                    _handleLogout();
                  },
                  child: SvgPicture.asset('assets/svg/profile_avatar.svg')),
              );
            },
          ),

          Expanded(
            child: Padding(
              padding: AppSpacing.paddingHorizontalXL,
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.md.h),
                  CustomOutlineButton(
                    borderRadius: AppSpacing.radiusXXL.r,
                    width: 200.w,
                    isFullWidth: false,
                    icon: SvgPicture.asset('assets/svg/microphone.svg'),
                    text: 'INICIAR AUDIO',
                    onPressed: () {},
                    textColor: AppColors.primary,
                    borderColor: AppColors.primary,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Divider(color: AppColors.primary, thickness: 2),
                ],
              ),
            ),
          ),
        ],
    );
  }
}
