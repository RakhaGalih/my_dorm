import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class MyNotificationService {
  static Future<String> getAccessToken() async {
    try {
      String contents =
          await rootBundle.loadString('assets/service_account.json');

      Map<String, dynamic> serviceAccountJson = jsonDecode(contents);
      print("serviceAccountJson: ${serviceAccountJson}");

      List<String> scopes = [
        'https://www.googleapis.com/auth/firebase.messaging'
      ];

      http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      // Get the access token
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      client.close();

      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      rethrow;
    }
  }

  // Send notification to the selected user
  static Future<void> sendNotificationToSelectedUser(String deviceToken,
      BuildContext context, String title, String desc) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/my-dorm-f2cad/messages:send';
      var uuid = Uuid();
      String tripID = uuid.v4();

      final Map<String, dynamic> message = {
        'message': {
          'token': deviceToken,
          'notification': {'title': title, 'body': desc},
          'data': {
            'tripID': tripID,
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print("Failed to send Notification: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  // Send notifikasi ke semua pengguna
  static Future<void> sendNotificationToAllUsers(
      BuildContext context, String title, String desc) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/my-dorm-f2cad/messages:send';
      var uuid = Uuid();
      String tripID = uuid.v4();

      final Map<String, dynamic> message = {
        'message': {
          'topic': mydorm_news_topic,
          'notification': {'title': title, 'body': desc},
          'data': {
            'tripID': tripID,
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully to all users.");
      } else {
        print(
            "Failed to send Notification to all users: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification to all users: $e");
    }
  }
}
