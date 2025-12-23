import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/core/widgets/custom_text_field.dart';
import 'package:booster/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../layout/main_layout_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar la política de privacidad'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
            SignUpRequested(
              name: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainLayoutPage(),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
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
                      SizedBox(height: AppSpacing.xxl.h),
                      _buildCreateAccountText(),
                      SizedBox(height: AppSpacing.xxxl.h),
                      _buildCreateAccountForm(),
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

  Widget _buildCreateAccountText() {
    return RichText(
      text: TextSpan(
        text: 'Registrate ',
        style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        children: [
          TextSpan(
            text: 'Ahora',
            style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Introduce tu nombre',
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg.h),
          CustomTextField(
            hintText: 'Introduce tu correo',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.alternate_email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg.h),
          // Password field
          CustomTextField(
            hintText: 'Introduce tu contraseña',
            controller: _passwordController,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg.h),
          // Confirm Password field
          CustomTextField(
            hintText: 'Confirma tu contraseña',
            controller: _confirmPasswordController,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  'Estoy de acuerdo con la política de privacidad',
                  style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),  
          SizedBox(height: AppSpacing.xxl.h),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return PrimaryButton(
                text: 'Ingresar',
                onPressed: state is AuthLoading ? null : _handleCreateAccount,
                isLoading: state is AuthLoading,
              );
            },
          ),
          SizedBox(height: AppSpacing.xxl.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ya tengo una cuenta ',
                style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Iniciar sesión',
                  style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Center(),
        ],
      ),
    );
  }
}
