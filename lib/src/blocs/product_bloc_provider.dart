import 'package:rxdart/subjects.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/providers/product_provider.dart';

class ProductBlocProvider {
  final ProductProvider _productProvider = ProductProvider();

  final _productListController = BehaviorSubject<List<Product>>();
  final _productNameController = BehaviorSubject<String>();
  final _productPriceController = BehaviorSubject<double>();
  final _productStockController = BehaviorSubject<int>();

  Future<List<Product>> getProducts({int status = 1}) async {
    final response = await _productProvider.getProducts(status: status);
    changeProductList(response);
    return response;
  }

  //Streams
  Stream<List<Product>> get productListStream => _productListController.stream;

  Stream<String> get productNameStream => _productNameController.stream;

  Stream<double> get productPriceStream => _productPriceController.stream;

  Stream<int> get productStockStream => _productStockController.stream;

  Function(List<Product>) get changeProductList =>
      _productListController.sink.add;

  dispose() {
    _productListController.close();
    _productNameController.close();
    _productPriceController.close();
    _productStockController.close();
  }
}
