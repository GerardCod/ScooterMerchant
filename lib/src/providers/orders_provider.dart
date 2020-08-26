import 'package:http/http.dart' as http;
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'dart:convert';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/src/models/order_model.dart';

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
    } else {
      return {'ok': true, 'message': decodedData['message']};
    }
  }
}
