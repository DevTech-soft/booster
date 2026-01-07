import 'dart:developer';
import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/widgets/primary_button.dart';
import 'package:booster/core/widgets/upload_widget.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/presentation/pages/interview_detail_page.dart';
import 'package:booster/features/projects/presentation/bloc/bloc.dart';
import 'package:booster/features/projects/presentation/widgets/microphone_selector_widget.dart';
import 'package:booster/features/projects/presentation/widgets/wave_form_widget.dart';
import 'package:booster/features/records/domain/entities/record_with_audio.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_bloc.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_event.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_state.dart';
import 'package:booster/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RecordStateWidget extends StatelessWidget {
  final String? projectId;
  final String? tenantId;
  final String? advisorId;
  final InterviewType? interviewType;

  const RecordStateWidget({
    super.key,
    this.projectId,
    this.tenantId,
    this.advisorId,
    this.interviewType,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordingBloc>(create: (_) => RecordingBloc()),
        BlocProvider<RecordUploadBloc>(create: (_) => sl<RecordUploadBloc>()),
      ],
      child: _RecordStateContent(
        projectId: projectId,
        tenantId: tenantId,
        advisorId: advisorId,
        interviewType: interviewType,
      ),
    );
  }
}

class _RecordStateContent extends StatelessWidget {
  final String? projectId;
  final String? tenantId;
  final String? advisorId;
  final InterviewType? interviewType;

  const _RecordStateContent({
    this.projectId,
    this.tenantId,
    this.advisorId,
    this.interviewType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 468.h,
      width: 317.w,
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: BlocBuilder<RecordingBloc, RecordingState>(
        builder: (context, state) {
          final showWaveform =
              state is RecordingInProgress ||
              state is RecordingStopped ||
              state is AudioPlaying ||
              state is AudioPaused;

          return Column(
            children: [
              // Selector de micrófono
              if (state is RecordingInitial) ...[
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                  child: MicrophoneSelectorWidget(
                    onDeviceSelected: (deviceId, deviceName) {
                      context.read<RecordingBloc>().add(
                        SelectAudioDevice(
                          deviceId: deviceId,
                          deviceName: deviceName,
                        ),
                      );
                    },
                  ),
                ),
              ],

              SizedBox(
                height: 300.h,
                child:
                    showWaveform
                        ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Visualización de waves
                              SizedBox(
                                height: 100.h,
                                child: _buildWaveform(state),
                              ),
                              SizedBox(height: 20.h),
                              // Temporizador
                              _buildTimer(state),
                            ],
                          ),
                        )
                        : const SizedBox.shrink(),
              ),

              // Botón de control (siempre en la misma posición)
              _buildControlButton(context, state),
              AppSpacing.verticalSpaceXL,

              if (state is RecordingStopped ||
                  state is AudioPlaying ||
                  state is AudioPaused) ...[
                BlocConsumer<RecordUploadBloc, RecordUploadState>(
                  listener: (context, uploadState) {
                    if (uploadState is RecordUploadInProgress) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );
                    }

                    if (uploadState is InterviewCreating) {
                      // Ya está el loader mostrando, no hacemos nada
                    }

                    if (uploadState is InterviewCreated) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); 
                      log(uploadState.interviewId);
                      _showInterviewCreatedBottomSheet(
                        context,
                        uploadState.interviewId,
                      );
                    }

                    if (uploadState is InterviewCreationFailed) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // cerrar loader

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return UploadResultSheet(
                            title: 'Error al crear entrevista',
                            message:
                                'El audio se subió correctamente pero hubo un error al crear la entrevista: ${uploadState.message}',
                          );
                        },
                      );
                    }

                    if (uploadState is RecordUploadSuccess) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // cerrar loader

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return UploadResultSheet(
                            title: 'Audio enviado',
                            message:
                                'El audio fue procesado correctamente por el servidor.',
                          );
                        },
                      );
                    }

                    if (uploadState is RecordUploadFailure) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // cerrar loader

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(uploadState.message)),
                      );
                    }
                  },
                  builder: (context, uploadState) {
                    return PrimaryButton(
                      text:
                          uploadState is RecordUploadInProgress
                              ? 'Subiendo audio...'
                              : uploadState is InterviewCreating
                                  ? 'Creando entrevista...'
                                  : 'Guardar Audio',
                      isFullWidth: false,
                      width: 200.w,
                      onPressed:
                          uploadState is RecordUploadInProgress ||
                                  uploadState is InterviewCreating
                              ? null
                              : () {
                                if (state is RecordingWithAudio) {
                                  // Capturar datos adicionales si el estado es RecordingStopped
                                  DateTime? startedAt;
                                  DateTime? endedAt;
                                  int? durationSec;

                                  if (state is RecordingStopped) {
                                    startedAt = state.startedAt;
                                    endedAt = state.endedAt;
                                    durationSec = state.finalDuration.inSeconds;
                                  }

                                  context.read<RecordUploadBloc>().add(
                                    RecordUploadStarted(
                                      audioPath: state.audioPath,
                                      transcription: '',
                                      projectId: projectId,
                                      tenantId: tenantId,
                                      advisorId: 
                                      "6fe97cd6-6206-4c3e-adc3-491592f1ecad",
                                      // advisorId,
                                      interviewType: interviewType,
                                      startedAt: startedAt,
                                      endedAt: endedAt,
                                      durationSec: durationSec,
                                    ),
                                  );
                                }
                              },
                    );
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimer(RecordingState state) {
    Duration duration = Duration.zero;

    if (state is RecordingInProgress) {
      duration = state.duration;
    } else if (state is RecordingStopped) {
      duration = state.finalDuration;
    } else if (state is AudioPlaying) {
      duration = state.totalDuration - state.currentPosition;
    } else if (state is AudioPaused) {
      duration = state.totalDuration - state.currentPosition;
    }

    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildWaveform(RecordingState state) {
    List<double> waveformData = [];
    double progress = 0.0;

    if (state is RecordingInProgress) {
      waveformData = state.waveformData;
      progress = 0.0;
    } else if (state is RecordingStopped) {
      waveformData = state.finalWaveformData;
      progress = 0.0;
    } else if (state is AudioPlaying) {
      waveformData = state.waveformData;
      progress =
          state.totalDuration.inMilliseconds > 0
              ? state.currentPosition.inMilliseconds /
                  state.totalDuration.inMilliseconds
              : 0.0;
    } else if (state is AudioPaused) {
      waveformData = state.waveformData;

      progress =
          state.totalDuration.inMilliseconds > 0
              ? state.currentPosition.inMilliseconds /
                  state.totalDuration.inMilliseconds
              : 0.0;
    }

    if (waveformData.isEmpty) {
      waveformData = List.filled(50, 0.1);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: WaveformPainter(
            waveformData: waveformData,
            primaryColor: AppColors.primary,
            isRecording: state is RecordingInProgress,
            playbackProgress: progress,
          ),
        );
      },
    );
  }

  Widget _buildControlButton(BuildContext context, RecordingState state) {
    final isRecording = state is RecordingInProgress;
    final hasRecording =
        state is RecordingStopped ||
        state is AudioPlaying ||
        state is AudioPaused;

    if (isRecording) {
      // Mostrar botón de stop cuando está grabando
      return _buildSingleButton(
        context: context,
        iconPath: 'assets/svg/stop.svg',
        color: AppColors.error,
        onTap: () {
          context.read<RecordingBloc>().add(const StopRecording());
        },
      );
    } else if (hasRecording) {
      return _buildPlaybackControls(context, state);
    } else {
      return _buildSingleButton(
        context: context,
        iconPath: 'assets/svg/play.svg',
        color: AppColors.primary,
        onTap: () {
          context.read<RecordingBloc>().add(const StartRecording());
        },
      );
    }
  }

  Widget _buildSingleButton({
    required BuildContext context,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 24.w,
            height: 24.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaybackControls(BuildContext context, RecordingState state) {
    final isPlaying = state is AudioPlaying;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de retroceder 5 segundos
        _buildControlIcon(
          iconPath: 'assets/svg/prev.svg',
          onTap: () {
            context.read<RecordingBloc>().add(const SeekBackward());
          },
        ),

        SizedBox(width: 24.w),

        // Botón de play/pause
        _buildSingleButton(
          context: context,
          iconPath: isPlaying ? 'assets/svg/pause.svg' : 'assets/svg/play.svg',
          color: AppColors.primary,
          onTap: () {
            log('isPlaying: $isPlaying');
            if (isPlaying) {
              context.read<RecordingBloc>().add(const PauseAudio());
            } else {
              context.read<RecordingBloc>().add(const PlayAudio());
            }
          },
        ),

        SizedBox(width: 24.w),

        _buildControlIcon(
          iconPath: 'assets/svg/next.svg',
          onTap: () {
            context.read<RecordingBloc>().add(const SeekForward());
          },
        ),
      ],
    );
  }

  Widget _buildControlIcon({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  void _showInterviewCreatedBottomSheet(
    BuildContext context,
    String interviewId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              // Icono de éxito
              Center(
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40.sp,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Título
              Center(
                child: Text(
                  'Entrevista creada exitosamente',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 12.h),

              // Mensaje
              Center(
                child: Text(
                  'El audio se ha subido y la entrevista se ha registrado correctamente. Ahora puedes ver su detalle y seguir su procesamiento.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 24.h),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(bottomSheetContext).pop();
                        // Resetear el estado del upload bloc
                        context.read<RecordUploadBloc>().add(const RecordUploadReset());
                      },
                      child: const Text('Cerrar'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(bottomSheetContext).pop();
                        // Navegar al detalle de la entrevista
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewDetailPage(
                              interviewId: interviewId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ver Detalle'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
