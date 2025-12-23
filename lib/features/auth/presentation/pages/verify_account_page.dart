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
import '../../../layout/main_layout_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({super.key});

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _temporaryPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _temporaryPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            VerifyAndSetPasswordRequested(
              email: _emailController.text.trim(),
              verificationCode: _verificationCodeController.text.trim(),
              temporaryPassword: _temporaryPasswordController.text,
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
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cuenta verificada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
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
                      SizedBox(height: AppSpacing.xl.h),
                      _buildHeaderText(),
                      SizedBox(height: AppSpacing.xl.h),
                      _buildVerificationCard(),
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
          'Verificar Cuenta de Vendedor',
          style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'Ingresa los datos para verificar tu cuenta',
          style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerificationCard() {
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
              label: 'Correo Electrónico',
              hintText: 'info@mybooster.ai',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                if (!value.contains('@')) {
                  return 'Por favor ingresa un correo válido';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomTextField(
              label: 'Código de Verificación',
              hintText: 'Código enviado a tu correo',
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.verified_user,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el código de verificación';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomTextField(
              label: 'Contraseña Temporal',
              hintText: 'Contraseña enviada a tu correo',
              controller: _temporaryPasswordController,
              obscureText: true,
              prefixIcon: Icons.lock_clock,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la contraseña temporal';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomTextField(
              label: 'Nueva Contraseña',
              hintText: 'Mínimo 8 caracteres',
              controller: _newPasswordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una nueva contraseña';
                }
                if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                }
                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                  return 'Debe incluir mayúsculas, minúsculas y números';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomTextField(
              label: 'Confirmar Nueva Contraseña',
              hintText: 'Repite la nueva contraseña',
              controller: _confirmPasswordController,
              obscureText: true,
              prefixIcon: Icons.lock,
              prefixIconColor: AppColors.primary,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor confirma tu nueva contraseña';
                }
                if (value != _newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.xxl.h),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  text: 'Verificar y Activar Cuenta',
                  onPressed: state is AuthLoading ? null : _handleVerify,
                  isLoading: state is AuthLoading,
                );
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            _buildInfoText(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSpacing.iconSM.sp,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              'Revisa tu correo para obtener el código de verificación y la contraseña temporal',
              style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}