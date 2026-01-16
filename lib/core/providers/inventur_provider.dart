import 'package:flutter/material.dart';
import 'package:inventur_mde/data/models/index.dart';
import '../../data/services/api_exception.dart';
import '../../data/services/api_service.dart';

class InventurProvider with ChangeNotifier {
  final ApiService apiService;

  InventurProvider(this.apiService);

  Future<InventurResponse> updateInventur(UpdateInventurRequest request) async {
    try{
      final response = await apiService.update(request);
      notifyListeners();
      return response;
    }
    catch (e){
      if (e is ApiException){
        return InventurResponse(nachricht: "API-Fehler (${e.statusCode}): ${e.message}.");
      }
      return InventurResponse(nachricht: "Ein Fehler ist aufgetreten: $e" );
    }
  }

  Future<InventurResponse> saveInventur(UpdateInventurRequest request) async {
    try{
      final response = await apiService.save(request);
      notifyListeners(); 
      return response;
    }
    catch (e){
      if (e is ApiException){
        return InventurResponse(nachricht: "API-Fehler (${e.statusCode}): ${e.message}.");
      }
      return InventurResponse(nachricht: "Ein Fehler ist aufgetreten: $e" );
    }
  }

}
