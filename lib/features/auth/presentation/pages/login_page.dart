import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/features/auth/presentation/pages/register_page.dart';
import 'package:booster/features/auth/presentation/pages/verify_account_page.dart';
import 'package:booster/features/layout/main_layout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/outline_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print('🔵 LOGIN - Disparando evento SignInRequested');
      print('🔵 Email: ${_emailController.text.trim()}');
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      print('❌ LOGIN - Validación del formulario falló');
    }
  }

  void _handleCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _handleForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print('🟢 LOGIN LISTENER - Nuevo estado: $state');

          if (state is Authenticated) {
            print('✅ LOGIN - Usuario autenticado: ${state.user.email}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayoutPage()),
            );
          } else if (state is AuthError) {
            print('❌ LOGIN - Error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthLoading) {
            print('⏳ LOGIN - Cargando...');
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/svg/back.svg'),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppSpacing.xxxl.h),
                      _buildWelcomeText(),
                      SizedBox(height: AppSpacing.xxxl.h),
                      _buildLoginCard(),
                      SizedBox(height: AppSpacing.xl.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Bienvenido a la plataforma',
          style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),

        Text(
          'Inicia sesión para continuar',
          style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
            fontSize: 16.sp,
            color: AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordText() {
    return InkWell(
      onTap: _handleForgotPassword,
      child: Text(
        'Olvidaste tu contraseña?',
        style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryLight,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.textSecondaryLight,
          decorationThickness: 1,
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xl.w,
        horizontal: AppSpacing.lg.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Email',
              hintText: 'info@mybooster.ai',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!value.contains('@')) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.lg.h),

            CustomTextField(
              label: 'Password',
              hintText: '************',
              controller: _passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.md.h),
            _buildRememberMeRow(),
            SizedBox(height: AppSpacing.lg.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildForgotPasswordText()],
            ),
            SizedBox(height: AppSpacing.xl.h),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  text: 'Ingresar',
                  onPressed: state is AuthLoading ? null : _handleLogin,
                  isLoading: state is AuthLoading,
                );
              },
            ),

            SizedBox(height: AppSpacing.md.h),

            _buildCreateAccountLink(),

            SizedBox(height: AppSpacing.lg.h),

            _buildDividerWithText(),

            SizedBox(height: AppSpacing.lg.h),

            CustomOutlineButton(
              text: 'Verificar Vendedor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifyAccountPage(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/LOGO_ISOTIPO_NEGATIVO.png',
                width: AppSpacing.iconMD.w,
                height: AppSpacing.iconMD.h,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.g_mobiledata,
                    size: AppSpacing.iconMD.sp,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        SizedBox(
          height: 24.h,
          width: 24.w,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXS.r),
            ),
          ),
        ),
        AppSpacing.horizontalSpaceSM,
        Text(
          'Recordarme',
          style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tengo cuenta? ',
          style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
        GestureDetector(
          onTap: _handleCreateAccount,
          child: Text(
            'Crear cuenta',
            style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.textDisabledLight.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Text(
            'Eres un vendedor?',
            style: AppTypography.lightTextTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.textDisabledLight.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
