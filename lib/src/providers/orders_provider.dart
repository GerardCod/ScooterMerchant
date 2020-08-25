import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/src/models/order_model.dart';

class OrdersProvider {
  String _baseUrl = baseUrl;
  MerchantPreferences _prefs = new MerchantPreferences();

  OrdersProvider();

  Future<List<OrderModel>> getOrders() async {
    final merchant = _prefs.merchant;
    final url = _baseUrl + 'merchants/${merchant.id}/orders/';

    http.Response response = await http.get(url, headers: {
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
}
