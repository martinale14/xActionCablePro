class ActionResponse {
  final Map<String, dynamic>? data;
  final String? error;

  bool get hasError => error != null;

  const ActionResponse({required this.data, required this.error});
}
