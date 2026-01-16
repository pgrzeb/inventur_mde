class GetArtResponse {
  final int artnr;
  final String? artbez;
  final String? nachricht;
  final int? menge;

  GetArtResponse(
      {required this.artnr,
      this.artbez,
      this.nachricht,
      this.menge});

  factory GetArtResponse.fromJson(Map<String, dynamic> json) {
    return GetArtResponse(
        artnr: json['artnr'],
        artbez: json['artbez'],
        nachricht: json['nachricht'],
        menge: json['menge']);
  }
}
