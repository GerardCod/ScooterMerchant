import 'dart:convert';

import 'package:flutter/material.dart';
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
    Uri uri;
    if (allProducts) {
      uri = Uri.https(
        _baseUri,
        '/appback/api/v1/merchants/${_prefs.merchant.id}/products/',
      );
    } else {
      uri = Uri.https(_baseUri,
          '/appback/api/v1/merchants/${_prefs.merchant.id}/products/', {
        'status': status.toString(),
      });
    }

    final http.Response response = await http
        .get(uri, headers: {'Authorization': 'Bearer ' + _prefs.access});

    if (response.statusCode >= 400) {
      return [];
    }

    String source = Utf8Decoder().convert(response.bodyBytes);
    Map<String, dynamic> decodedData = json.decode(source);
    List<dynamic> list = decodedData['results'];
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> updateProduct(
      {@required Product product}) async {
    final Uri uri = Uri.https(_baseUri,
        '/appback/api/v1/merchants/${_prefs.merchant.id}/products/${product.id}/');
    // print('Product Available Provider');
    // print(product.isAvailable);
    Map<String, dynamic> body = {
      'name': product.name,
      'price': product.price,
      // 'stock': product.stock
      'is_available': product.isAvailable
    };
    final http.Response response =
        await http.patch(uri, body: json.encode(body), headers: {
      'Authorization': 'Bearer ' + _prefs.access,
      'Content-Type': 'application/json',
    });

    String source = Utf8Decoder().convert(response.bodyBytes);
    Map<String, dynamic> decodedData = json.decode(source);

    if (response.statusCode >= 400) {
      // print(decodedData);
      return {'ok': false, 'message': 'Error al actualizar el producto.'};
    }
    return {'ok': true, 'message': 'Producto actualizado.'};
  }
}
