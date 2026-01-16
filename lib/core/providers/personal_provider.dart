import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventur_mde/data/services/api_service.dart';
import 'package:inventur_mde/data/models/index.dart';

import '../../data/services/api_exception.dart';

class PersonalProvider with ChangeNotifier {
  final ApiService apiService;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  int? _komnr;
  int? get komnr => _komnr;

  String? _komna;
  String? get komna => _komna;

  PersonalProvider(this.apiService);

  Future<PersonalLoginResponse> login(PersonalLoginRequest request) async {
    try {
      final response = await apiService.login(request);
      if (response.nachricht == null) {
        _komnr = response.komnr;
        _komna = response.komna;
        await _storage.write(key: 'komnr', value: _komnr.toString());
        await _storage.write(key: 'komna', value: _komna);
        notifyListeners();
      }
      return response;
    } catch (e) {
      if (e is ApiException){
        return PersonalLoginResponse(nachricht: "API-Fehler (${e.statusCode}): ${e.message}.", komnr: 0, komna: "", pin: "", rechte: 0);
      }
      return PersonalLoginResponse(nachricht: "Unbekannter Fehler: $e", komnr: 0, komna: "", pin: "", rechte: 0);
    }
  }

  Future<void> loadUserData() async {
    final value = await _storage.read(key: 'komnr');
    final komnaValue = await _storage.read(key: 'komna');
    _komnr = int.tryParse(value ?? '');
    _komna = komnaValue ?? '';
    notifyListeners();
  }
  
  Future<void> clearKomnr() async {
    await _storage.delete(key: 'komnr');
    _komnr = null;
    notifyListeners();
  }
}
