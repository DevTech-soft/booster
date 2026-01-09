import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/primary_button.dart';
import 'package:booster/features/clients/data/datasources/clients_remote_datasource.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientFormDialog extends StatefulWidget {
  final InterviewType interviewType;
  final String tenantId;
  final Function(String clientId, String audioType) onClientSelected;

  const ClientFormDialog({
    super.key,
    required this.interviewType,
    required this.onClientSelected,
    required this.tenantId
  });

  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _datasource = ClientsRemoteDatasourceImpl();

  // Controllers
  final _fullNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _ageController = TextEditingController();

  // State
  String _maritalStatus = 'Soltero';
  bool _isLoading = false;
  bool _isReadOnly = false;
  String? _clientId;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dniController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _isVisita => widget.interviewType == InterviewType.visita;

  Future<void> _handleSearch() async {
    if (_dniController.text.trim().isEmpty) {
      _showError('Por favor ingresa un DNI');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final clientData = await _datasource.getClientByDni(_dniController.text.trim());

      setState(() {
        _clientId = clientData['id'];
        _fullNameController.text = clientData['full_name'] ?? '';
        _ageController.text = clientData['age']?.toString() ?? '';
        _maritalStatus = clientData['marital_status'] ?? 'Soltero';
        _isReadOnly = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('No se encontró un cliente con ese DNI');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      String clientId;
      String audioType;

      if (_isVisita) {
        // Crear nuevo cliente
        final clientData = await _datasource.createClient(
          fullName: _fullNameController.text.trim(),
          dni: _dniController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          maritalStatus: _maritalStatus,
          tenantId: widget.tenantId,
        );
        clientId = clientData['id'];
        audioType = 'visitas';
      } else {
        // Usar cliente existente
        if (_clientId == null) {
          _showError('Por favor busca un cliente primero');
          setState(() => _isLoading = false);
          return;
        }
        clientId = _clientId!;
        audioType = 'cliente';
      }

      setState(() => _isLoading = false);

      // Cerrar diálogo y retornar datos
      if (mounted) {
        Navigator.of(context).pop();
        widget.onClientSelected(clientId, audioType);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error al procesar: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isVisita ? 'Nueva Visita' : 'Buscar Cliente'),
      content: SizedBox(
        width: 400.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // DNI field (always shown)
                TextFormField(
                  controller: _dniController,
                  decoration: InputDecoration(
                    labelText: 'DNI',
                    hintText: 'Ingresa el DNI',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
                    ),
                    suffixIcon: !_isVisita && !_isReadOnly
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _isLoading ? null : _handleSearch,
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enabled: !_isLoading && !_isReadOnly,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El DNI es obligatorio';
                    }
                    if (value.trim().length < 8) {
                      return 'El DNI debe tener al menos 8 dígitos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.md.h),

                // Show additional fields for visita or after client search
                if (_isVisita || _isReadOnly) ...[
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      hintText: 'Ingresa el nombre completo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
                      ),
                    ),
                    enabled: !_isLoading && !_isReadOnly,
                    validator: (value) {
                      if (_isVisita && (value == null || value.trim().isEmpty)) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Edad',
                      hintText: 'Ingresa la edad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    enabled: !_isLoading && !_isReadOnly,
                    validator: (value) {
                      if (_isVisita && (value == null || value.trim().isEmpty)) {
                        return 'La edad es obligatoria';
                      }
                      if (value != null && value.isNotEmpty) {
                        final age = int.tryParse(value);
                        if (age == null || age <= 0 || age > 120) {
                          return 'Ingresa una edad válida';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  DropdownButtonFormField<String>(
                    value: _maritalStatus,
                    decoration: InputDecoration(
                      labelText: 'Estado Civil',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
                      ),
                    ),
                    items: ['Soltero', 'Casado', 'Divorciado', 'Viudo']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: _isLoading || _isReadOnly
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _maritalStatus = value);
                            }
                          },
                  ),
                ],

                if (!_isVisita && !_isReadOnly) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    'Ingresa el DNI y presiona buscar',
                    style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_isVisita || _isReadOnly)
          PrimaryButton(
            width: 120.w,
            isFullWidth: false,
            text: _isLoading
                ? 'Procesando...'
                : (_isVisita ? 'Guardar' : 'Continuar'),
            onPressed: _isLoading ? null : _handleSubmit,
          ),
      ],
    );
  }
}
