import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:scootermerchant/src/models/current_order_status_model.dart';
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrdersProvider {
  String _baseUri = baseUri;
  MerchantPreferences _prefs = new MerchantPreferences();

  OrdersProvider();

  // Future<List<OrderModel>> getOrders(
  //     {int status = 14, bool inProcess = false, bool allOrders = false}) async {
  //   final merchant = _prefs.merchant;
  //   Uri uri;
  //   if (allOrders) {
  //     uri = Uri.https(
  //         _baseUri, '/appback/api/v1/merchants/${merchant.id}/orders/');
  //   } else {
  //     uri = Uri.https(
  //         _baseUri, '/appback/api/v1/merchants/${merchant.id}/orders/', {
  //       'order_status': status.toString(),
  //       'in_process': inProcess.toString()
  //     });
  //   }

  //   http.Response response = await http.get(uri, headers: {
  //     'Authorization': 'Bearer ' + _prefs.access,
  //   });

  //   String source = Utf8Decoder().convert(response.bodyBytes);
  //   final Map<String, dynamic> decodedData = json.decode(source);

  //   if (decodedData == null || decodedData.containsKey('errors')) {
  //     return [];
  //   }

  //   List<dynamic> results = decodedData['results'];
  //   return results.map((e) => OrderModel.fromJson(e)).toList();
  // }

  Future<List<OrderModel>> getOrders({String status, String ordering}) async {
    final merchant = _prefs.merchant;
    Uri uri;
    uri = Uri.https(
        _baseUri, '/api/v1/merchants/${merchant.id}/orders/', {
      'order_status': status.toString(),
      'ordering': ordering.toString(),
    });
    // print(uri);

    // print(uri);
    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer ' + _prefs.access,
    });

    String source = Utf8Decoder().convert(response.bodyBytes);
    final Map<String, dynamic> decodedData = json.decode(source);

    if (decodedData == null || decodedData.containsKey('errors')) {
      return [];
    }

    List<dynamic> results = decodedData['results'];
    return results.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> acceptOrder(OrderModel model) async {
    try {
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
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> orderReady(OrderModel model) async {
    try {
      final MerchantModel merchant = _prefs.merchant;
      final Uri uri = Uri.https(_baseUri,
          '/api/v1/merchants/${merchant.id}/orders/${model.id}/order_ready/');

      // print('uri=============================');
      // print(uri);

      http.Response response = await http.put(uri,
          headers: {'Authorization': 'Bearer ' + _prefs.access}, body: {});
      // print(response);

      String source = Utf8Decoder().convert(response.bodyBytes);

      final Map<String, dynamic> decodedData = json.decode(source);

      if (response.statusCode >= 400) {
        return {'ok': false, 'message': decodedData['errors']['message']};
      }
      return {'ok': true, 'message': decodedData['message']};
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> rejectOrder(
      OrderModel model, String message) async {
    try {
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
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> cancelOrder(
      OrderModel model, String reason) async {
    try {
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
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    try {
      final MerchantModel merchant = _prefs.merchant;
      final Uri uri = Uri.https(_baseUri,
          '/api/v1/merchants/${merchant.id}/orders/' + orderId + '/');

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

  Future<CurrentOrderStatusModel> getCurrentOrderStatus(String orderId) async {
    try {
      CurrentOrderStatusModel orderModel;
      final MerchantModel merchant = _prefs.merchant;
      final url = baseUrl +
          'merchants/${merchant.id}/orders/$orderId/current_status/';
      // print('Url=========================================');
      // print(url);
      // return orderModel;
      http.Response resp = await http.get(Uri.encodeFull(url), headers: {
        "Authorization": "Bearer " + _prefs.access,
        'Content-type': 'application/json'
      });
      String source = Utf8Decoder().convert(resp.bodyBytes);
      Map<String, dynamic> decodedData = json.decode(source);

      orderModel = CurrentOrderStatusModel.fromJson(decodedData['data']);

      return orderModel;
    } catch (error) {
      print(error);
    }
  }
}
