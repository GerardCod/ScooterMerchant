import 'package:http/http.dart' as http;
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'dart:convert';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/src/models/order_model.dart';

import '../models/merchant_model.dart';

class OrdersProvider {
  String _baseUri = baseUri;
  MerchantPreferences _prefs = new MerchantPreferences();

  OrdersProvider();

  Future<List<OrderModel>> getOrders(
      {int status = 14, bool inProcess = false}) async {
    final merchant = _prefs.merchant;
    var uri = Uri.https(_baseUri, '/api/v1/merchants/${merchant.id}/orders/', {
      'order_status': status.toString(),
      'in_process': inProcess.toString()
    });

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer ' + _prefs.access,
    });

    String source = Utf8Decoder().convert(response.bodyBytes);
    final Map<String, dynamic> decodedData = json.decode(source);

    if (decodedData == null || decodedData.containsKey('error')) {
      return [];
    }

    List<dynamic> results = decodedData['results'];

    return results.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> acceptOrder(OrderModel model) async {
    final MerchantModel merchant = _prefs.merchant;
    final Uri uri = Uri.https(
      _baseUri,
      '/api/v1/merchants/${merchant.id}/orders/${model.id}/accept_order/',
    );

    http.Response response = await http.put(uri, headers: {
      'Authorization': 'Bearer ' + _prefs.access,
    }, body: {});

    String source = Utf8Decoder().convert(response.bodyBytes);

    final Map<String, dynamic> decodedData = json.decode(source);

    if (response.statusCode >= 400) {
      return {'ok': false, 'message': decodedData['errors']['message']};
    }
    return {'ok': true, 'message': decodedData['message']};
  }

  Future<Map<String, dynamic>> orderReady(OrderModel model) async {
    final MerchantModel merchant = _prefs.merchant;
    final Uri uri = Uri.https(_baseUri,
        '/api/v1/merchants/${merchant.id}/orders/${model.id}/order_ready/');

    http.Response response = await http.put(uri,
        headers: {'Authorization': 'Bearer ' + _prefs.access}, body: {});

    String source = Utf8Decoder().convert(response.bodyBytes);

    final Map<String, dynamic> decodedData = json.decode(source);

    if (response.statusCode >= 400) {
      return {'ok': false, 'message': decodedData['errors']['message']};
    }
    return {'ok': true, 'message': decodedData['message']};
  }

  Future<Map<String, dynamic>> rejectOrder(
      OrderModel model, String message) async {
    final MerchantModel merchant = _prefs.merchant;
    final Uri uri = Uri.https(_baseUri,
        '/api/v1/merchants/${merchant.id}/orders/${model.id}/reject_order/');

    http.Response response = await http.put(uri,
        headers: {'Authorization': 'Bearer ' + _prefs.access},
        body: {'reason_rejection': message.toString()});

    String source = Utf8Decoder().convert(response.bodyBytes);

    final Map<String, dynamic> decodedData = json.decode(source);

    if (response.statusCode >= 400) {
      return {'ok': false, 'message': decodedData['errors']['message']};
    }
    return {'ok': true, 'message': decodedData['message']};
  }

  Future<Map<String, dynamic>> cancelOrder(
      OrderModel model, String reason) async {
    final MerchantModel merchant = _prefs.merchant;
    final Uri uri = Uri.https(_baseUri,
        '/api/v1/merchants/${merchant.id}/orders/${model.id}/cancel_order/');

    http.Response response = await http.put(uri,
        headers: {'Authorization': 'Bearer ' + _prefs.access},
        body: {'reason_rejection': reason});

    String source = Utf8Decoder().convert(response.bodyBytes);
    Map<String, dynamic> decodedData = json.decode(source);

    if (response.statusCode >= 400) {
      return {'ok': false, 'message': decodedData['errors']['message']};
    }
    return {'ok': true, 'message': decodedData['message']};
  }

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    try {
      final MerchantModel merchant = _prefs.merchant;
      final Uri uri = Uri.https(
          _baseUri, 'api/v1/merchants/${merchant.id}/orders/' + orderId + '/');

      http.Response resp = await http.get(uri, headers: {
        "Authorization": "Bearer " + _prefs.access,
      });
      String source = Utf8Decoder().convert(resp.bodyBytes);

      Map<String, dynamic> jsonResp = json.decode(source);

      if (resp.statusCode >= 400) {
        return {'ok': false, 'message': jsonResp['errors']['message']};
      } else {
        return {'ok': true, 'order': OrderModel.fromJson(jsonResp)};
      }
    } catch (error) {
      print(error);
    }
  }
}
