class UpdateInventurRequest {
  final int artnr;
  final String? artbez;
  final int menge;
  final int benutzer; 

  UpdateInventurRequest({
    required this.artnr, 
    required this.menge, 
    required this.benutzer,
    this.artbez});

  Map<String, dynamic> toJson() {
    return {
      'artnr': artnr,
      'artbez': artbez,
      'menge': menge,
      'benutzer': benutzer,
    };
  }
}
