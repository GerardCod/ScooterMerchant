import 'dart:convert';

import 'package:scootermerchant/src/models/merchant_model.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:http/http.dart' as http;

class ProductProvider {
  final String _baseUri = baseUri;
  final MerchantPreferences _prefs = MerchantPreferences();

  ProductProvider();

  Future<List<Product>> getProducts(
      {int status = 1, bool allProducts = false}) async {
    try {
      Uri uri;

      if (allProducts) {
        uri = Uri.https(
          _baseUri,
          '/api/v1/merchants/${_prefs.merchant.id}/products/',
        );
      } else {
        uri = Uri.https(
            _baseUri, '/api/v1/merchants/${_prefs.merchant.id}/products/', {
          'status': status.toString(),
        });
      }

      final http.Response response = await http
          .get(uri, headers: {'Authorization': 'Bearer ' + _prefs.access});

      if (response.statusCode >= 400) {
        return [];
      }

      String source = Utf8Decoder().convert(response.bodyBytes);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
