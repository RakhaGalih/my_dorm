import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as serviceControl;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "my-dorm-f2cad",
      "private_key_id": "ee5e17b453cf4937a4cfaaeccb2340204bc09962",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC0u9XXiG7UkarI\n27l/dwl1fYutDSE+KYTeK6qtLfVE5tXmY5a+EJ3DDzRp/o3rSdllnizRA6R+oNuh\nVC3uzz0pVhFWDzKsVOcoDc6WcsvMLLKUyqYkWy79RjPCMxDnN68gsVDDo/rKIRYh\ndj2LNt5q+In/7NCGNmYXCzTfCIlLWcuuMGljXtGvS7HIwMZv/+npJguf8AvQ7QMl\nOoDt4ziYM75CHNdMFdRx0+U3T9iVEtQ36yl8O3cxYVt4JKa7iSWb6woK8LKZdjb0\n/LSaVGbvP7uKnkL6qMW1aKs74LK7y0jxat/1zqT+o3wdoPo0Ky0CAjCmlHQ9TT10\nQrzJA4QHAgMBAAECggEABtEu97pFs+7qqjjffldXG/9oTVa5ckbOpDKxdWbOYZLz\nboVDIlguGzVvnK/lWoKmmJamyhuBEOWwYx1xvhhDDlQYw04/cxCgx3n92N7roP/u\nnH4oVia6VwNW4HRcptwK1wjZKwf8ZbNpyklTePTQ3ugRDH46P1W99BCQJfmEdDsW\noNrV4nqEv8lW67zO3RKAmuEvnpPdVcBXrSUbtOloNtyWmBMc/YgultQMPiMbghu1\nQAT4J0FeP5GaBC++dVGDyJhyiwhw4PQIk3ynyW6EVKvKUKy4AocILmOzrcMPnSfI\nd0dXB1QlnK9vbNDLK6x86FvuCsj4pek5YxQpsOUfwQKBgQDbLyHtFFQEnl4l4wwo\nlD5Tupz3cuq8rwKByTlDK1qDIW3yEPadw9Bit7WESZcN4VGAXtGPj+Z6knPnwnFa\nxICglLb8LirSkuInSg9E3nnnrbm7h8cyZoOKxAZmc+iId2MrhgKbH1Xgqg/mCoYL\nAXibOdMK7cYeUNMgnGrXFXSQIwKBgQDTF1hZynGcxpAP7ZqqF0Pl/KQo6Y2aW1JU\n4bkTTFxEw1LnDIT5rDBONHXhHddGbxKVvYfFZSHhLxkyfS53WaAEZTY27QiTqUeu\nyQoYHPYRkQt9ej25qp0URXyQ2X96m3Wd7lO7crm0gMqrLMPyDJ90SIL9Qm+Ik6LH\n5IY2XlkIzQKBgD7y7GVwfyjMavGqoaVN3hCh+c6/fFcwVCH+Lqnx247pnO/2mz14\nLXMMm98gW3erDIM3uCvpAiKVyR/4oiGVafO0glEu2TGc6cKq7HO1CYHWTQ9k0XrS\nIllKLyRhiZkX4K1xUXJHr5xUezhwMUsb4w2Br/DllQ7D277z7WNUUCPNAoGALxpm\nfKLP90vXmbZLbOkEHa3ic76p+memV4qG4eeIL0/mj+gbRBtILCtIopMmFnFylDdW\ntJV8meMInFuSos89Bb4P+vGpmEmN1VLHDdpojkLvbXB5lZScuIlI4ommCJXoCPXF\neW6AQeb7UncKwlhOvIPxttG8UZ2gFTrJOBiVhYECgYA9/YVlSZ2NE9c4x1c6Lu9r\nMaMYMlIzwPUFvO2MuPeUXJJrd3DOosq7wfx/BaO3kJvF3JN7hG/yjREXodG27WLn\nT9PxrnRfSsgzZdQv/A/qk5eqs5UZgJ/itflIj41fWSw8zevvl2bDNjb6P0IVE9yN\nq7cN9b15aN88dtSYxlDr7A==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-upmnl@my-dorm-f2cad.iam.gserviceaccount.com",
      "client_id": "106328549556625958347",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-upmnl%40my-dorm-f2cad.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedUser(String deviceToken,
      BuildContext context, String title, String desc) async {
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
  }
}
