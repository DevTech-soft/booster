import 'package:booster/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic_info/mic_info.dart';
import 'package:mic_info/model/mic_info_model.dart';

class MicrophoneSelectorWidget extends StatefulWidget {
  final Function(String deviceId, String deviceName) onDeviceSelected;
  final String? currentDeviceId;

  const MicrophoneSelectorWidget({
    super.key,
    required this.onDeviceSelected,
    this.currentDeviceId,
  });

  @override
  State<MicrophoneSelectorWidget> createState() =>
      _MicrophoneSelectorWidgetState();
}

class _MicrophoneSelectorWidgetState extends State<MicrophoneSelectorWidget> {
  List<MicInfoDevice> _audioDevices = [];
  bool _isLoading = false;
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _selectedDeviceId = widget.currentDeviceId;
    _loadAudioDevices();
  }

  Future<void> _loadAudioDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final devices = await MicInfo.getBluetoothMicrophones();
      setState(() {
        _audioDevices = devices ?? [];
        _isLoading = false;

        // Si no hay dispositivo seleccionado, seleccionar el primero por defecto
        if (_selectedDeviceId == null && _audioDevices.isNotEmpty) {
          _selectedDeviceId = _audioDevices.first.id;
          widget.onDeviceSelected(
            _audioDevices.first.id ?? '',
            _audioDevices.first.productName ?? 'Unknown',
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading audio devices: $e');
    }
  }

  void _showDeviceSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Seleccionar Micrófono',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300.h,
            child:
                _audioDevices.isEmpty
                    ? const Center(
                      child: Text('No hay dispositivos disponibles'),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _audioDevices.length,
                      itemBuilder: (context, index) {
                        final device = _audioDevices[index];
                        final isSelected = device.id == _selectedDeviceId;

                        return ListTile(
                          title: Text(
                            device.productName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              color:
                                  isSelected
                                      ? AppColors.primary
                                      : AppColors.textBlack,
                            ),
                          ),
                          leading: Icon(
                            isSelected ? Icons.mic : Icons.mic_none,
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.textBlack,
                          ),
                          trailing:
                              isSelected
                                  ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedDeviceId = device.id;
                            });
                            widget.onDeviceSelected(
                              device.id,
                              device.productName,
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: 24.w,
        height: 24.w,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return GestureDetector(
      onTap: _showDeviceSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 16.w, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              _audioDevices.isEmpty
                  ? 'Sin micrófono'
                  : _audioDevices
                          .firstWhere(
                            (d) => d.id == _selectedDeviceId,
                            orElse: () => _audioDevices.first,
                          )
                          .productName
                          ?.split(' ')
                          .take(2)
                          .join(' ') ??
                      'Seleccionar',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_drop_down, size: 16.w, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
