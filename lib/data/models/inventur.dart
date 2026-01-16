class Inventur {
  final int? id;
  final int artnr;
  final String? artbez;
  final int menge;
  final DateTime datum;
  final int benutzer; 

  Inventur({
    required this.artnr, 
    required this.menge, 
    required this.benutzer,
    required this.datum,
    this.id,
    this.artbez});

  Map<String, dynamic> toJson() {
    return {
      'artnr': artnr,
      'artbez': artbez,
      'menge': menge,
      'datum': datum,
      'benutzer': datum.toIso8601String(),
    };
  }

  factory Inventur.fromJson(Map<String, dynamic> json){
    return Inventur (
      id: json['id'],
      artnr: json['artnr'],
      artbez: json['artbez'],
      menge: json['menge'],
      datum: DateTime.parse(json['datum']),
      benutzer: json['benutzer'],
    );
  }
}
