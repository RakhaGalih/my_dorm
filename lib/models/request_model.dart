class RequestModel {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime date;
  RequestModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.date,
  });
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['log_keluar_masuk_id'].toString(),
      name: json['dormitizen']?['nama'] ?? 'Tidak diketahui',
      type: json['aktivitas'] ?? 'tidak ada',
      date: DateTime.parse(json['waktu']),
      status: json['status'] ?? 'unknown',
    );
  }
}
