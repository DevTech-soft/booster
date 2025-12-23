import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar el almacenamiento de la API Key
/// La API Key tiene formato: sk_live_<64_caracteres_hex>
class ApiKeyService {
  static const String _apiKeyKey = 'api_key';
  final SharedPreferences _prefs;

  ApiKeyService(this._prefs);

  /// Guarda la API Key en almacenamiento local
  Future<bool> saveApiKey(String apiKey) async {
    try {
      return await _prefs.setString(_apiKeyKey, apiKey);
    } catch (e) {
      return false;
    }
  }

  /// Obtiene la API Key almacenada
  /// Retorna null si no hay API Key guardada
  String? getApiKey() {
    return _prefs.getString(_apiKeyKey);
  }

  /// Verifica si hay una API Key guardada
  bool hasApiKey() {
    return _prefs.containsKey(_apiKeyKey);
  }

  /// Elimina la API Key almacenada
  Future<bool> clearApiKey() async {
    try {
      return await _prefs.remove(_apiKeyKey);
    } catch (e) {
      return false;
    }
  }

  /// Valida el formato de la API Key
  /// Formato esperado: sk_live_<64_caracteres_hex> o sk_test_<64_caracteres_hex>
  bool validateApiKeyFormat(String apiKey) {
    final regex = RegExp(r'^sk_(live|test)_[a-fA-F0-9]{64}$');
    return regex.hasMatch(apiKey);
  }
}
