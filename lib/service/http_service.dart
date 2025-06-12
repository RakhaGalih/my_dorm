import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart'; // Added for basename function
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_dorm/models/request_model.dart';

const String apiURL =
    "https://mydorm-mobile-backend-production-5f66.up.railway.app";

Future<Map<String, dynamic>> getDataToken(String address, String token) async {
  final uri = Uri.parse(apiURL + address);
  final response = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    throw Exception('Unauthorized or Forbidden');
  } else {
    print('Failed to load user details. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load user details');
  }
}

Future<Map<String, dynamic>> logout(String token) async {
  final uri = Uri.parse("$apiURL/logout");
  final response = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('we got here');
    return jsonDecode(response.body);
  } else {
    print('Failed to load user details. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load user details');
  }
}

Future<Map<String, dynamic>> postData(
    String address, Map<String, dynamic> body) async {
  final uri = Uri.parse(apiURL + address);
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    print('Failed to post data. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return jsonDecode(response.body);
  }
}

// POST request dengan token dan gambar
Future<dynamic> postDataTokenWithImage(
  String endpoint,
  Map<String, String> data,
  File? imageFile,
) async {
  String? token = await getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var request = http.MultipartRequest('POST', Uri.parse('$apiURL$endpoint'));
  request.headers['Authorization'] = 'Bearer $token';
  var mimeType = lookupMimeType(imageFile!.path);
  var bytes = await File.fromUri(Uri.parse(imageFile.path)).readAsBytes();
  http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'gambar', bytes,
      filename: basename(imageFile.path),
      contentType: MediaType.parse(mimeType.toString()));
  request.fields.addAll(data);
  request.headers.addAll(headers);
  request.files.add(multipartFile);
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Tambahkan field data ke request
  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  return _handleResponse(response);
}

// Post Data token dengan File
Future<dynamic> postDataTokenWithFile(
  String endpoint,
  Map<String, String> data,
  File? imageFile,
) async {
  String? token = await getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var request = http.MultipartRequest('POST', Uri.parse('$apiURL$endpoint'));
  request.headers['Authorization'] = 'Bearer $token';
  var mimeType = lookupMimeType(imageFile!.path);
  var bytes = await File.fromUri(Uri.parse(imageFile.path)).readAsBytes();
  http.MultipartFile multipartFile = http.MultipartFile.fromBytes('file', bytes,
      filename: basename(imageFile.path),
      contentType: MediaType.parse(mimeType.toString()));
  request.fields.addAll(data);
  request.headers.addAll(headers);
  request.files.add(multipartFile);
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Tambahkan field data ke request
  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  return _handleResponse(response);
}

Future<dynamic> updateDataToken(
    String address, Map<String, dynamic> body) async {
  final uri = Uri.parse(apiURL + address);
  String? token = await getToken();
  final response = await http.patch(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  _handleResponse(response);
}

// POST request dengan token dan gambar
Future<dynamic> updateDataTokenWithImage(
  String endpoint,
  Map<String, String> data,
  File? imageFile,
) async {
  String? token = await getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var request = http.MultipartRequest('PUT', Uri.parse('$apiURL$endpoint'));
  request.headers['Authorization'] = 'Bearer $token';
  var mimeType = lookupMimeType(imageFile!.path);
  var bytes = await File.fromUri(Uri.parse(imageFile.path)).readAsBytes();
  http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'gambar', bytes,
      filename: basename(imageFile.path),
      contentType: MediaType.parse(mimeType.toString()));
  request.fields.addAll(data);
  request.headers.addAll(headers);
  request.files.add(multipartFile);
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Tambahkan field data ke request
  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  return _handleResponse(response);
}

// UPDATE data token dengan File
Future<dynamic> updateDataTokenWithFile(
  String endpoint,
  Map<String, String> data,
  File? imageFile,
) async {
  String? token = await getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var request = http.MultipartRequest('PUT', Uri.parse('$apiURL$endpoint'));
  request.headers['Authorization'] = 'Bearer $token';
  var mimeType = lookupMimeType(imageFile!.path);
  var bytes = await File.fromUri(Uri.parse(imageFile.path)).readAsBytes();
  http.MultipartFile multipartFile = http.MultipartFile.fromBytes('file', bytes,
      filename: basename(imageFile.path),
      contentType: MediaType.parse(mimeType.toString()));
  request.fields.addAll(data);
  request.headers.addAll(headers);
  request.files.add(multipartFile);
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Tambahkan field data ke request
  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  return _handleResponse(response);
}

// Fungsi untuk menangani response
dynamic _handleResponse(http.Response response) {
  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Response body: ${response.body}');
    return jsonDecode(response.body);
  } else {
    print('Failed to post data. Status code: ${response.statusCode}');
    print(response.body);
    throw Exception('Failed to POST');
  }
}

Future<dynamic> postDataToken(String address, Map<String, dynamic> body) async {
  final uri = Uri.parse(apiURL + address);
  String? token = await getToken();
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  _handleResponse(response);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<void> saveToken(String token, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', token);
  await prefs.setString('role', role);
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
  await prefs.remove('role');
}

Future<String?> getRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}

Future<dynamic> postTokenFCM(String fcmtoken) async {
  String address = "/notification/saveToken";
  final uri = Uri.parse(apiURL + address);
  String? token = await getToken();
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      "fcm_token": fcmtoken,
    }),
  );

  _handleResponse(response);
}

// delete request dengan token
Future<dynamic> deleteDataToken(String endpoint) async {
  final uri = Uri.parse('$apiURL$endpoint');
  String? token = await getToken();

  final response = await http.delete(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  return _handleResponse(response);
}

// get all log keluar masuk (gedung ini)
Future<List<RequestModel>> fetchLogKeluarMasuk() async {
  String address = "/log-keluar-masuk";
  final uri = Uri.parse(apiURL + address);
  String? token = await getToken();

  final response = await http.get(uri, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> logs = data['data'];
    return logs.map((json) => RequestModel.fromJson(json)).toList();
  } else {
    throw Exception('Gagal mengambil data log keluar masuk.');
  }
}

// get all log keluar masuk (dormitizen loged in)
Future<List<RequestModel>> fetchLogKeluarMasukOfDormitizen() async {
  final uri = Uri.parse('$apiURL/log-keluar-masuk/me');
  String? token = await getToken();

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List data = jsonData['data'];
    return data.map((e) => RequestModel.fromJson(e)).toList();
  } else {
    throw Exception('Gagal mengambil data log keluar masuk');
  }
}

// Terima atau Tolak request keluar masuk
Future<void> updateStatusLog(String id, String aksi) async {
  final uri = Uri.parse('$apiURL/log-keluar-masuk/status/$aksi/$id');
  String? token = await getToken();

  final response = await http.put(uri, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    print('Status berhasil diubah menjadi $aksi');
  } else {
    final body = jsonDecode(response.body);
    throw Exception('Gagal mengubah status: ${body['message']}');
  }
}

// cek status kamar dormitizen
Future<String> fetchStatusKamar() async {
  final uri = Uri.parse('$apiURL/log-keluar-masuk/status');
  String? token = await getToken();

  final response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['status'];
  } else {
    throw Exception('Gagal mengambil status kamar');
  }
}

// Request keluar/masuk
Future<void> requestKeluarMasuk() async {
  final uri = Uri.parse(
      '$apiURL/log-keluar-masuk/request'); // ganti jika endpoint berbeda
  String? token = await getToken();

  final response = await http.post(uri, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode != 201) {
    throw Exception('Request gagal dengan kode: ${response.statusCode}');
  }
}

// Tambah Log Keluar/Masuk Manual
Future<dynamic> addLogManual(Map<String, String> data) async {
  final uri = Uri.parse('$apiURL/log-keluar-masuk/tambah');
  String? token = await getToken();

  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  final responseBody = jsonDecode(response.body);

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return responseBody;
  } else {
    throw Exception(responseBody['message'] ?? 'Gagal mengirim data');
  }
}


Future<dynamic> updateDataTokenTanpaBody(String endpoint) async {
  final uri = Uri.parse('$apiURL$endpoint');
  String? token = await getToken();

  final response = await http.put(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  return _handleResponse(response);
}
