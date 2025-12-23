import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ForgotPasswordRequested(
              email: _emailController.text.trim(),
            ),
          );
    }
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ConfirmResetPasswordRequested(
              email: _emailController.text.trim(),
              code: _codeController.text.trim(),
              newPassword: _newPasswordController.text,
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
          if (state is ForgotPasswordCodeSent) {
            setState(() {
              _codeSent = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Código de recuperación enviado a tu email'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is Unauthenticated) {
            if (_codeSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña restablecida exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
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
                      SizedBox(height: AppSpacing.xxxl.h),
                      _buildHeaderText(),
                      SizedBox(height: AppSpacing.xxxl.h),
                      _buildForm(),
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

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _codeSent ? 'Restablecer Contraseña' : 'Recuperar Contraseña',
          style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          _codeSent
              ? 'Ingresa el código y tu nueva contraseña'
              : 'Ingresa tu email para recibir el código',
          style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
            fontSize: 16.sp,
            color: AppColors.textBlack,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
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
              enabled: !_codeSent,
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
            if (_codeSent) ...[
              SizedBox(height: AppSpacing.lg.h),
              CustomTextField(
                label: 'Código de verificación',
                hintText: '123456',
                controller: _codeController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.verified_user,
                prefixIconColor: AppColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el código';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.lg.h),
              CustomTextField(
                label: 'Nueva contraseña',
                hintText: '************',
                controller: _newPasswordController,
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                prefixIconColor: AppColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nueva contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.lg.h),
              CustomTextField(
                label: 'Confirmar contraseña',
                hintText: '************',
                controller: _confirmPasswordController,
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                prefixIconColor: AppColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirma tu contraseña';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
            ],
            SizedBox(height: AppSpacing.xl.h),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  text: _codeSent ? 'Restablecer Contraseña' : 'Enviar Código',
                  onPressed: state is AuthLoading
                      ? null
                      : (_codeSent ? _handleResetPassword : _handleSendCode),
                  isLoading: state is AuthLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
