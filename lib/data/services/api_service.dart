import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventur_mde/data/models/index.dart';

import 'api_exception.dart';

class ApiService {
  static const String baseUrl = "http://192.168.125.111:5000";

  Future<PersonalLoginResponse> login(PersonalLoginRequest request) async {
    try{
      final response = await http.post(
      Uri.parse('$baseUrl/personal/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PersonalLoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ApiException(response.statusCode,
          'Der Login schlug fehl.',
          response.body,
        );
    }
    } catch (e) {
      if (e is ApiException) {
        rethrow; 
      }
      throw ApiException(
        0, 
        'Netzwerkfehler: Der Server ist nicht erreichbar. Ist das MDE-Gerät verbunden?',
        e.toString(),
      );
    }
  }

  Future<GetArtResponse> getArt(int artnr) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inventur/getArt?artnr=$artnr'),
      );

      if (response.statusCode == 200) {
        return GetArtResponse.fromJson(json.decode(response.body));
      } else {
        // Wenn der Statuscode NICHT 200 ist, werfen wir unsere spezifische Exception
        throw ApiException(
          response.statusCode,
          'Die Artikelsuche schlug fehl.',
          response.body,
        );
      }
    }  catch (e) {
      // Hier werden z.B. DNS-Lookup-Fehler oder SocketExceptions (Netzwerk nicht erreichbar) gefangen.
      if (e is ApiException) {
        rethrow; // Spezifische API-Fehler weitergeben
      }
      // Andere Netzwerkfehler (z.B. Timeout, keine Verbindung)
      throw ApiException(
        0, // Statuscode 0 für generische Netzwerkfehler
        'Netzwerkfehler: Der Server ist nicht erreichbar. Ist das MDE-Gerät verbunden?',
        e.toString(),
      );
    }
  }

  Future<InventurResponse> save(UpdateInventurRequest request) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/inventur/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return InventurResponse.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          response.statusCode,
          'Das Sichern der Inventur schlug fehl.',
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow; 
      }
      throw ApiException(
        0, 
        'Netzwerkfehler: Der Server ist nicht erreichbar. Ist das MDE-Gerät verbunden?',
        e.toString(),
      );
    }
  }

  Future<InventurResponse> update(UpdateInventurRequest request) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/inventur/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return InventurResponse.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          response.statusCode,
          'Das Sichern der Inventur schlug fehl.',
          response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow; 
      }
      throw ApiException(
        0, 
        'Netzwerkfehler: Der Server ist nicht erreichbar. Ist das MDE-Gerät verbunden?',
        e.toString(),
      );
    }
  }
}
