import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/providers/product_provider.dart';

class ProductBlocProvider with Validators {
  final ProductProvider _productProvider = ProductProvider();

  int count;
  int limit = 15;
  int offset = 0;

  final _productListController = BehaviorSubject<List<ProductModel>>();
  final _productNameController = BehaviorSubject<String>();
  final _productPriceController = BehaviorSubject<double>();
  // final _productStockController = BehaviorSubject<int>();
  final _productAvailableController = BehaviorSubject<bool>();
  final _showLoaderController = BehaviorSubject<bool>();

  //Streams
  Stream<List<ProductModel>> get productListStream =>
      _productListController.stream;
  Stream<String> get productNameStream =>
      _productNameController.stream.transform(validateProductName);
  Stream<double> get productPriceStream =>
      _productPriceController.stream.transform(validateProductPrice);
  // Stream<int> get productStockStream =>
  //     _productStockController.stream.transform(validateProductStock);
  Stream<bool> get productAvailableStream => _productAvailableController.stream;
  Stream<bool> get showLoaderStream => _showLoaderController.stream;
  Stream<bool> get validateProductInformation => Rx.combineLatest2(
      productNameStream,
      productPriceStream,
      (a, b) => (a != null && b != null));

  //Modifiers
  Function(List<ProductModel>) get changeProductList =>
      _productListController.sink.add;
  Function(String) get changeProductName => _productNameController.sink.add;
  Function(double) get changeProductPrice => _productPriceController.sink.add;
  // Function(int) get changeProductStock => _productStockController.sink.add;
  Function(bool) get changeProductAvailable =>
      _productAvailableController.sink.add;
  Function(bool) get changeShowLoader => _showLoaderController.sink.add;

  //Getters
  List<ProductModel> get productList => _productListController.value;
  String get productName => _productNameController.value;
  double get productPrice => _productPriceController.value;
  // int get productStock => _productStockController.value;
  bool get productAvailable => _productAvailableController.value;
  bool get showLoader => _showLoaderController.value;

  // Future<List<ProductModel>> getProducts() async {
  //   final response = await _productProvider.getProducts();
  //   // print(response);
  //   changeProductList(response);
  //   return response;
  // }

  Future<List<ProductModel>> getProducts(
      {String category,
      String subcategory,
      String orderBy,
      String lat,
      String lng}) async {
    List<ProductModel> productsTemp = [];

    if (productList != null) {
      // changeLoaderList
      productsTemp = productList;
    }
    if (count != null &&
        productsTemp.length > 0 &&
        count <= productsTemp.length) {
      return [];
    }
    if (productsTemp.length > 0) {
      // changeLoaderList(true);
      offset = offset + 15;
      limit = limit + 15;
    }

    Map<String, dynamic> listTemp = await _productProvider.getProducts(
      limit: limit,
      offset: offset,
    );
    // limit;
    count = listTemp['count'];
    productsTemp.addAll(listTemp['products']);
    changeProductList(productsTemp);
    // print('ProductList length');
    // print(productList.length);
    // changeLoaderList(false);
  }

  Future<Map<String, dynamic>> updateProduct(
      {@required ProductModel product}) async {
    changeShowLoader(true);
    Map<String, dynamic> response =
        await _productProvider.updateProduct(product: product);
    changeShowLoader(false);
    return response;
  }

  cleanProductState() {
    this._productNameController.value = null;
    this._productPriceController.value = null;
    this._productAvailableController.value = null;
  }

  dispose() {
    _productListController.close();
    _showLoaderController.close();
    _productNameController.close();
    _productPriceController.close();
    // _productStockController.close();
    _productAvailableController.close();
  }
}
