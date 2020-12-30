import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:http/http.dart' as http;

class ProductProvider {
  final String _baseUri = baseUri;
  final MerchantPreferences _prefs = MerchantPreferences();

  // ProductProvider();

  Future<Map<String, dynamic>> getProducts({
    int limit,
    int offset,
  }) async {
    dynamic queryParameters = {'': ''};
    if (limit != null) {
      queryParameters['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParameters['offset'] = offset.toString();
    }

    Uri uri = Uri.https(_baseUri,
        '/api/v1/merchants/${_prefs.merchant.id}/products/', queryParameters);
    http.Response resp = await http
        .get(uri, headers: {'Authorization': 'Bearer ' + _prefs.access});

    String source = Utf8Decoder().convert(resp.bodyBytes);

    Map<String, dynamic> decodedData = json.decode(source);
    final List<ProductModel> products = new List();

    if (decodedData == null) return {};

    if (decodedData['error'] != null) return {};
    List<dynamic> listDecoded = decodedData['results'];
    // print('listDecoded===========================');
    // print(decodedData);

    listDecoded.forEach((product) {
      final productTemp = ProductModel.fromJson(product);
      products.add(productTemp);
    });

    return {'count': decodedData['count'], 'products': products};
  }

  Future<Map<String, dynamic>> updateProduct(
      {@required ProductModel product}) async {
    final Uri uri = Uri.https(_baseUri,
        '/api/v1/merchants/${_prefs.merchant.id}/products/${product.id}/');
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

  Future<List<ProductModel>> getProductsSearch({dynamic search}) async {
    dynamic queryParameters = {'': ''};
    // int areaId = _prefs.areaId;

    // queryParameters['area_id'] = areaId.toString();

    if (search != null) {
      queryParameters['search'] = search.toString();
    }

    var uri = Uri.https(_baseUri, '/api/v1/merchants/${_prefs.merchant.id}/products/', queryParameters);

    http.Response resp = await http.get(uri, headers: {'Authorization': 'Bearer ' + _prefs.access});

    String source = Utf8Decoder().convert(resp.bodyBytes);

    Map<String, dynamic> decodedData = json.decode(source);
    final List<ProductModel> merchants = new List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];
    List<dynamic> listDecoded = decodedData['results'];

    listDecoded.forEach((merchant) {
      final addressTemp = ProductModel.fromJson(merchant);

      merchants.add(addressTemp);
    });

    return merchants;
  }
}
