import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AudioDetailsPage extends StatefulWidget {
  const AudioDetailsPage({super.key});

  @override
  State<AudioDetailsPage> createState() => _AudioDetailsPageState();
}

class _AudioDetailsPageState extends State<AudioDetailsPage> {
  // Datos hardcodeados - TODO: Reemplazar con datos del endpoint
  final String audioTitle = 'Lorem Ipsum';
  final String audioTimestamp = '3:30 pm';
  final double audioProgress = 0.0; // 0.0 a 1.0
  final Duration currentPosition = Duration.zero;
  final Duration totalDuration = const Duration(minutes: 0, seconds: 2);
  final bool isPlaying = false;

  final String transcription =
      '''Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.

Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen.

No sólo sobrevivió 500 años, sino que también ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas "Letraset",''';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
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
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSpacing.md.h),

                    _buildSearchBar(),

                    SizedBox(height: AppSpacing.lg.h),
                    Divider(
                      color: AppColors.textDisabledLight.withValues(alpha: 0.5),
                      thickness: 1,
                    ),
                    _buildAudioHeader(),

                    SizedBox(height: AppSpacing.lg.h),

                    _buildAudioPlayer(),

                    SizedBox(height: AppSpacing.lg.h),
                    Divider(
                      color: AppColors.textDisabledLight.withValues(alpha: 0.5),
                      thickness: 1,
                    ),
                    _buildTranscription(),

                    SizedBox(height: AppSpacing.xl.h),

                    _buildSaveButton(),

                    SizedBox(height: AppSpacing.lg.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 33.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXL.r),
          border: Border.all(color: AppColors.primary),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: _searchController,
          maxLines: 1,
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 14.sp,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 14.w,
                height: 14.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                audioTitle,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                audioTimestamp,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Mostrar menú de opciones
          },
          icon: Icon(Icons.more_horiz, color: AppColors.primary, size: 24.w),
        ),
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return Column(
      children: [
        // Slider de progreso
        Row(
          children: [
            Text(
              _formatDuration(currentPosition),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.borderLight,
                  thumbColor: AppColors.primary,
                ),
                child: Slider(
                  value: audioProgress,
                  onChanged: (value) {
                    setState(() {
                      // audioProgress = value;
                    });
                  },
                ),
              ),
            ),
            Text(
              '-${_formatDuration(totalDuration - currentPosition)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(icon: 'prev', onTap: () {}),

                SizedBox(width: AppSpacing.lg.w),

                // Botón Play/Pause
                GestureDetector(
                  onTap: () {
                    // TODO: Play/Pause audio
                  },
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  ),
                ),

                SizedBox(width: AppSpacing.lg.w),

                // Botón adelantar 5 segundos
                _buildControlButton(icon: 'next', onTap: () {}),

                SizedBox(width: AppSpacing.xxxl.w),
              ],
            ),
            _buildControlButton(
              icon: 'trash',
              color: AppColors.error,
              onTap: () {
                
              },
            ),
            Spacer(flex: 1),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16.w,
        height: 19.w,
        child: SvgPicture.asset('assets/svg/$icon.svg'),
      ),
    );
  }

  Widget _buildTranscription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transcription,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textBlack,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Guardar audio/transcripción
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 0,
      ),
      child: Text(
        'Guardar',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(1, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
