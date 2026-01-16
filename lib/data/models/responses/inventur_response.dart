class InventurResponse {
  final String nachricht;

  InventurResponse({required this.nachricht});

  factory InventurResponse.fromJson(Map<String, dynamic> json) {
    return InventurResponse(
        nachricht: json['nachricht']);
  }
}
