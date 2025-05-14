// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:prodrivers/components/notification.dart';

import 'config.dart';

class AuthAPI {
  final _storage = const FlutterSecureStorage();
  final box = GetStorage();

  Future<String?> getToken() async {
    print(await _storage.read(key: 'token'));
    print(await _storage.read(key: 'userType'));
    box.write("userType", await _storage.read(key: 'userType'));
    return await _storage.read(key: 'token');
  }



  static Future UploadSingleFiles({required filePath}) async {
    // print("================filePath>> $filePath");
    // print("================FULL UPLOAD URL-- ${API_URL}upload/file");

    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: "token");

    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}upload/file'));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer ${token.toString()}",
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // print(await response.stream.bytesToString());
      // print(json.decode(await response.stream.bytesToString()));
      return json.decode(await response.stream.bytesToString());
    } else {
      // print(response.statusCode);
      // print(response.reasonPhrase);
      return null;
    }
  }

  static Future POST_FORMS_TO_API(
      {required String url, required formData}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$API_URL/$url'));
    request.fields.addAll(formData);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(await response.stream.bytesToString());
      }
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  // static Future uploadImage({required ImageFilePath}) async {
  //   print(ImageFilePath);
  //   try {
  //     final UPLOAD_ANSWER = AuthAPI.UploadSingleFiles(
  //         url: "upload/file", filePath: ImageFilePath);
  //     print(UPLOAD_ANSWER);
  //     return UPLOAD_ANSWER;
  //   } catch (e) {
  //     print('uploading error $e');
  //   }
  // }

  static Future POST_FORM_WITH_TOKEN({
    required String urlendpoint,
    required postData,
  }) async {
    final _storage = const FlutterSecureStorage();
    final client = http.Client();

    final token = await _storage.read(key: "token");
    print(token.toString());

    try {
      final httpresponse = await client.post(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        body: json.encode(postData),
        headers: {
          HttpHeaders.acceptHeader: 'multiform/data',
          HttpHeaders.authorizationHeader: "Bearer ${token.toString()}",
        },
        encoding: Encoding.getByName('utf-8')!,
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        notifyInfo(content: res["message"]);
        if (kDebugMode) {
          // print(res);
          print(res["message"]);
        }
      } else {
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }

  static Future POST_WITH_TOKEN({
    required String urlendpoint,
    required postData,
  }) async {
    final _storage = const FlutterSecureStorage();
    final client = http.Client();

    final token = await _storage.read(key: "token");
    print(token.toString());

    try {
      final httpresponse = await client.post(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        body: json.encode(postData),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${token.toString()}",
        },
        encoding: Encoding.getByName('utf-8')!,
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        notifyInfo(content: res["message"]);
        if (kDebugMode) {
          // print(res);
          print(res["message"]);
        }
      } else {
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }

    static Future PATCH_WITH_TOKEN({
    required String urlendpoint,
    required postData,
  }) async {
    final _storage = const FlutterSecureStorage();
    final client = http.Client();

    final token = await _storage.read(key: "token");
    print(token.toString());

    try {
      final httpresponse = await client.patch(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        body: json.encode(postData),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${token.toString()}",
        },
        encoding: Encoding.getByName('utf-8')!,
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        notifyInfo(content: res["message"]);
        if (kDebugMode) {
          // print(res);
          print(res["message"]);
        }
      } else {
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }

  static Future POST_WITHOUT_TOKEN({
    required String urlendpoint,
    required postData,
  }) async {
    final client = http.Client();
    print("object");

    try {
      final httpresponse = await client.post(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        body: json.encode(postData),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        encoding: Encoding.getByName('utf-8')!,
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        if (urlendpoint == 'auth/login') {

        } else {
          notifyInfo(content: res["message"]);
        }
        
        if (kDebugMode) {
          print(res);
          print(res["message"]);
        }
      } else {
        print(res);
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }

  static Future GET_WITH_TOKEN({
    required String urlendpoint,
  }) async {
    final _storage = const FlutterSecureStorage();
    final client = http.Client();

    final token = await _storage.read(key: "token");
    print(token.toString());
    try {
      final httpresponse = await client.get(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${token.toString()}",
        },
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        // notifyInfo(content: res["message"]);
        // if (kDebugMode) {
        //   // print(res);
        //   print(res["message"]);
        // }
      } else {
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }

  static Future TOKENIZED_GET(
      {required String urlendpoint, required String token}) async {
    final client = http.Client();
    print(token.toString());
    try {
      final httpresponse = await client.get(
        Uri.parse(
          '$API_URL$urlendpoint',
        ),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      final res = json.decode(httpresponse.body);

      if (httpresponse.statusCode >= 500) {
        notifyInfo(content: httpresponse.reasonPhrase!);
      }

      if (httpresponse.statusCode == 200 || httpresponse.statusCode == 201) {
        notifyInfo(content: res["message"]);
        if (kDebugMode) {
          // print(res);
          print(res["message"]);
        }
      } else {
        notifyInfo(content: res["message"]);
      }

      return res;
    } catch (error, trace) {
      if (kDebugMode) {
        print(error);
        print(trace);
      }
    } finally {
      client.close();
    }
  }
}
