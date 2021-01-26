import 'dart:io';

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
  final _productDescriptionController = BehaviorSubject<String>();
  final _productPriceController = BehaviorSubject<double>();
  final _productAvailableController = BehaviorSubject<bool>();
  final _listMenuCategoriesController =
      BehaviorSubject<List<MenuCategoriesModel>>();
  final _showLoaderController = BehaviorSubject<bool>();
  final _loaderProductsSearchController = BehaviorSubject<bool>();
  final _listProductsSearchController = BehaviorSubject<List<ProductModel>>();
  final _optionAvailableController = BehaviorSubject<bool>();
  final _imagePickedController = BehaviorSubject<File>();

  //Streams
  Stream<List<ProductModel>> get productListStream =>
      _productListController.stream;
  Stream<String> get productNameStream =>
      _productNameController.stream.transform(validateProductName);
  Stream<String> get productDescriptionStream =>
      _productDescriptionController.stream.transform(validateProductName);
  Stream<double> get productPriceStream =>
      _productPriceController.stream.transform(validateProductPrice);
  Stream<bool> get productAvailableStream => _productAvailableController.stream;
  Stream<List<MenuCategoriesModel>> get listMenuCategoriesStream =>
      _listMenuCategoriesController.stream;
  Stream<bool> get showLoaderStream => _showLoaderController.stream;
  Stream<bool> get loaderProductsSearchStream =>
      _loaderProductsSearchController.stream;
  Stream<List<ProductModel>> get listProductsSearchStream =>
      _listProductsSearchController.stream;
  Stream<bool> get optionAvailableStream => _optionAvailableController.stream;
  Stream<File> get imagePickedStream => _imagePickedController.stream;

  // Validators
  Stream<bool> get validateProductInformation => Rx.combineLatest2(
      productNameStream,
      productPriceStream,
      (a, b) => (a != null && b != null));

  //Modifiers
  Function(List<ProductModel>) get changeProductList =>
      _productListController.sink.add;
  Function(String) get changeProductName => _productNameController.sink.add;
  Function(String) get changeProductDescription =>
      _productDescriptionController.sink.add;
  Function(double) get changeProductPrice => _productPriceController.sink.add;
  Function(bool) get changeProductAvailable =>
      _productAvailableController.sink.add;
  Function(List<MenuCategoriesModel>) get changeListMenuCategories =>
      _listMenuCategoriesController.sink.add;
  Function(bool) get changeShowLoader => _showLoaderController.sink.add;
  Function(bool) get changeLoaderProductsSearch =>
      _loaderProductsSearchController.sink.add;
  Function(List<ProductModel>) get changeListProductsSearch =>
      _listProductsSearchController.sink.add;
  Function(bool) get changeOptionAvailable =>
      _optionAvailableController.sink.add;
      Function(File) get changeImagePicked => _imagePickedController.sink.add;

  //Getters
  List<ProductModel> get productList => _productListController.value;
  String get productName => _productNameController.value;
  String get productDescription => _productDescriptionController.value;
  double get productPrice => _productPriceController.value;
  bool get productAvailable => _productAvailableController.value;
  List<MenuCategoriesModel> get listMenuCategories =>
      _listMenuCategoriesController.value;
  bool get showLoader => _showLoaderController.value;
  bool get loaderProductsSearch => _loaderProductsSearchController.value;
  List<ProductModel> get listProductsSearch =>
      _listProductsSearchController.value;
  bool get optionAvailable => _optionAvailableController.value;
  File get imagePicked => _imagePickedController.value;

  // Future<List<ProductModel>> getProducts() async {
  //   final response = await _productProvider.getProducts();
  //   // print(response);
  //   changeProductList(response);
  //   return response;
  // }

  Future<List<ProductModel>> getProducts() async {
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
      changeShowLoader(true);
      offset = offset + 15;
      limit = limit + 15;
    }

    // print('entro');
    Map<String, dynamic> listTemp = await _productProvider.getProducts(
      limit: limit,
      offset: offset,
    );
    // limit;
    count = listTemp['count'];
    productsTemp.addAll(listTemp['products']);
    changeProductList(productsTemp);

    changeShowLoader(false);
  }

  void changeStatusOption(
      OptionsModel option, MenuCategoriesModel menuOption, bool isAvailable) {
    MenuCategoriesModel categoriesModel;
    // Recorrer la lista de menucategories
    for (int i = 0; i < listMenuCategories.length; i++) {
      // Si el id de la lista de categorias que se recorre es igual a el que recibimos 
      // entonces asigno ese menu de categoria
      if (listMenuCategories[i].id == menuOption.id) {
        categoriesModel = listMenuCategories[i];
        // Vuelvo a recorrer la lista pero ahora de las opciones
        for (int j = 0; j < menuOption.options.length; j++) {
          // Si el id de la lista de opciones es igual a el id de la option que recibo
          if (option.id == menuOption.options[j].id) {
            // Cambiar la dispobibilidad de la opcion de las categorias asignadas
            categoriesModel.options[j].isAvailable = isAvailable;
            // Asignar la categoria a la lista de categorias correspondiente
            listMenuCategories[i] = categoriesModel;
            // print(categoriesModel.options[j].name);
            // print(categoriesModel.options[j].isAvailable);
            
            changeOptionAvailable(isAvailable);
          }
        }
      }
    }
  }

  Future<Map<String, dynamic>> updateProduct(
      {ProductModel product, File imagePicked}) async {
    changeShowLoader(true);
    Map<String, dynamic> response =
        await _productProvider.updateProduct(product, imagePicked);
    // changeShowLoader(false);
    return response;
  }

  Future<List<ProductModel>> searchProducts(String search) async {
    changeLoaderProductsSearch(true);
    List<ProductModel> response =
        await _productProvider.getProductsSearch(search: search);
    changeListProductsSearch(response);
    changeLoaderProductsSearch(false);
    return response;
  }

  cleanProductState() {
    this._productNameController.value = null;
    this._productDescriptionController.value = null;
    this._productPriceController.value = null;
    this._productAvailableController.value = null;
    this._imagePickedController.value = null;
  }

  dispose() {
    _productListController.close();
    _showLoaderController.close();
    _productNameController.close();
    _productDescriptionController.close();
    _productPriceController.close();
    _productAvailableController.close();
    _listMenuCategoriesController?.close();
    _loaderProductsSearchController.close();
    _listProductsSearchController.close();
    _optionAvailableController.close();
    _imagePickedController?.close();
  }
}
