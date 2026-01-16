import 'package:flutter/material.dart';
import 'package:inventur_mde/data/models/index.dart';

import '../../data/services/api_exception.dart';
import '../../data/services/api_service.dart';

class ScanProvider with ChangeNotifier {
  final ApiService apiService;

  ScanProvider(this.apiService);

  Future<GetArtResponse> loadArtikel(String ean) async {
    final trimmedEan = ean.trim(); 

    final artnrInt = int.tryParse(trimmedEan);

    if (artnrInt == null) {
      // Artikelnummer konnte nicht in eine Zahl konvertiert werden (z.B. leerer oder ungültiger Scan)
      return GetArtResponse(
        artnr: 0, 
        nachricht: "Ungültige Artikelnummer gescannt: '$trimmedEan'.",
      );
    }
    try {
      final response = await apiService.getArt(artnrInt);
      notifyListeners();
      return response;
    } catch (e) {
      if (e is ApiException){
        return GetArtResponse(artnr: artnrInt, nachricht: "API-Fehler (${e.statusCode}): ${e.message}.");
      }
      return GetArtResponse(artnr: artnrInt, nachricht: "Unbekannter Fehler: $e" );
    }
  }
}