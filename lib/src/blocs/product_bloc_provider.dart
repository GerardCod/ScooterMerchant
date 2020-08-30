import 'package:rxdart/subjects.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/providers/product_provider.dart';

class ProductBlocProvider {
  final ProductProvider _productProvider = ProductProvider();

  final _productListController = BehaviorSubject<List<Product>>();

  Future<List<Product>> getProducts() async {
    final response = await _productProvider.getProducts();
    changeProductList(response);
    return response;
  }

  Function(List<Product>) get changeProductList =>
      _productListController.sink.add;

  Stream<List<Product>> get productListStream => _productListController.stream;

  dispose() {
    _productListController.close();
  }
}
