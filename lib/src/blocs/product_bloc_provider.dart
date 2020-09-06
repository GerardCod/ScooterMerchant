import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/providers/product_provider.dart';

class ProductBlocProvider with Validators {
  final ProductProvider _productProvider = ProductProvider();

  final _productListController = BehaviorSubject<List<Product>>();
  final _productNameController = BehaviorSubject<String>();
  final _productPriceController = BehaviorSubject<double>();
  // final _productStockController = BehaviorSubject<int>();
  final _productAvailableController = BehaviorSubject<bool>();
  final _showLoaderController = BehaviorSubject<bool>();

  //Streams
  Stream<List<Product>> get productListStream => _productListController.stream;
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
  Function(List<Product>) get changeProductList =>
      _productListController.sink.add;
  Function(String) get changeProductName => _productNameController.sink.add;
  Function(double) get changeProductPrice => _productPriceController.sink.add;
  // Function(int) get changeProductStock => _productStockController.sink.add;
  Function(bool) get changeProductAvailable =>
      _productAvailableController.sink.add;
  Function(bool) get changeShowLoader => _showLoaderController.sink.add;

  //Getters
  String get productName => _productNameController.value;
  double get productPrice => _productPriceController.value;
  // int get productStock => _productStockController.value;
  bool get productAvailable => _productAvailableController.value;
  bool get showLoader => _showLoaderController.value;

  Future<List<Product>> getProducts({int status = 1}) async {
    final response = await _productProvider.getProducts(status: status);
    changeProductList(response);
    return response;
  }

  Future<Map<String, dynamic>> updateProduct(
      {@required Product product}) async {
    changeShowLoader(true);
    Map<String, dynamic> response =
        await _productProvider.updateProduct(product: product);
    changeShowLoader(false);
    return response;
  }

  dispose() {
    _productListController.close();
    _productNameController.close();
    _productPriceController.close();
    // _productStockController.close();
    _productAvailableController.close();
  }
}
