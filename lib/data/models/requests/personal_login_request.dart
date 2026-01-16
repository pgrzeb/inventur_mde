class PersonalLoginRequest {
  final int komnr;
  final String pin;

  PersonalLoginRequest({required this.komnr, required this.pin});

  Map<String, dynamic> toJson() {
    return {
      'komnr': komnr,
      'pin': pin,
    };
  }
}
