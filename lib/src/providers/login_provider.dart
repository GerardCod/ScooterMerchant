import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/src/models/auth_model.dart';

class LoginProvider {
  String _baseUrl = baseUrl;

  Future<Map<String, dynamic>> login(AuthModel model) async {
    try {
      final response =
          await http.post(_baseUrl + 'merchants/login/', body: model.toMap());
      String source = Utf8Decoder().convert(response.bodyBytes);
      Map<String, dynamic> decodedResp = json.decode(source);

      if (decodedResp.containsKey('access')) {}

      return decodedResp;
    } catch (e) {
      print(e);
    }
  }
}
