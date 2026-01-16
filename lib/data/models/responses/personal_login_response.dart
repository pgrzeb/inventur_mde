class PersonalLoginResponse {
  final int komnr;
  final String komna;
  final String pin;
  final int rechte;
  final String? nachricht;

  PersonalLoginResponse(
      {required this.komnr,
      required this.komna,
      required this.pin,
      required this.rechte,
      this.nachricht});

  factory PersonalLoginResponse.fromJson(Map<String, dynamic> json) {
    return PersonalLoginResponse(
        komnr: json['komnr'],
        komna: json['komna'],
        pin: json['pin'],
        rechte: json['rechte'],
        nachricht: json['nachricht']);
  }
}
