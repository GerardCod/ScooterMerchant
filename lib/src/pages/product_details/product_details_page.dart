import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/permissions/permissions_camera_page.dart';
import 'package:scootermerchant/src/pages/permissions/permissions_gallery_page.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductModel productModel;
  ProductDetailsPage(this.productModel);
  ProductBlocProvider productBlocProvider;
  Size size;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  // File _image;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    productBlocProvider = Provider.productBlocProviderOf(context);

    productBlocProvider.changeProductName(productModel.name);
    productBlocProvider.changeProductPrice(productModel.price);
    productBlocProvider.changeProductAvailable(productModel.isAvailable);
    productBlocProvider.changeProductDescription(productModel.description);
    productBlocProvider.changeListMenuCategories(productModel.menuCategories);
    return Scaffold(
      key: _scaffoldKey,
      body: _customBody(context),
      floatingActionButton: _customFloating(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _customAppBar() {
    return SliverAppBar(
      floating: true,
      title: Text('Detalles del producto', style: txtStyleAppBar),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  Widget _customBody(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        _customAppBar(),
        _containerImage(context),
        _switchDisponibility(),
        _productName(),
        _productPrice(),
        _showListMenuCategories(),
        SliverToBoxAdapter(child: SizedBox(height: 100))
      ],
    );
  }

  Widget _containerImage(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 220,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamBuilder<File>(
                stream: productBlocProvider.imagePickedStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.file(snapshot.data);
                  }
                  return FadeInImage(
                    fit: BoxFit.cover,
                    image: productModel.picture != null
                        ? NetworkImage('${productModel.picture}')
                        : AssetImage('assets/images/no_image.png'),
                    placeholder: AssetImage('assets/images/no_image.png'),
                  );
                }),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () => _cameraOptionsModal(context),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _cameraOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(
                  Icons.image,
                  color: accentColor,
                ),
                title: Text(
                  'Elegir imagen.',
                ),
                onTap: () {
                  _selectSource(ImageSource.gallery, context);
                },
              ),
              new ListTile(
                leading: new Icon(
                  Icons.camera_alt,
                  color: accentColor,
                ),
                title: Text(
                  'Tomar foto.',
                ),
                onTap: () {
                  _selectSource(ImageSource.camera, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectSource(ImageSource source, BuildContext context) async {
    if (source == ImageSource.gallery) {
      var resp = await _checkGalleryPermission(context);
      if (resp != null && resp) {
        final pickedFile =
            await picker.getImage(source: source, imageQuality: 30);
        if (pickedFile == null) {
          return;
        }
        File imageFile = new File(pickedFile.path);
        productBlocProvider.changeImagePicked(imageFile);
      }
    } else {
      var resp = await _checkCameraPermission(context);
      if (resp != null && resp) {
        final pickedFile =
            await picker.getImage(source: source, imageQuality: 30);
        if (pickedFile == null) {
          return;
        }
        File imageFile = new File(pickedFile.path);
        productBlocProvider.changeImagePicked(imageFile);
      }
    }
    // final pickedFile = await picker.getImage(source: source, imageQuality: 30);
    // if (pickedFile != null) {
    //   File imageFile = new File(pickedFile.path);
    //   productBlocProvider.changeImagePicked(imageFile);
    // }

    // Navigator.pop(context);

    // setState(() {
    //   _image = File(pickedFile.path);
    // });
  }

  Future<bool> _checkCameraPermission(BuildContext context) async {
    var resp = false;
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      await _confirmOpenSettings('Permisos de cámara denegados', context);
    }

    if (status.isUndetermined) {
      resp = await _openPagePermissionCamera(context);
    }

    if (status.isDenied) {
      resp = await _openPagePermissionCamera(context);
    }

    if ((resp != null && resp) || status.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> _checkGalleryPermission(BuildContext context) async {
    var resp = false;
    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied) {
      await _confirmOpenSettings('Permisos de galería denegados', context);
    }

    if (status.isUndetermined) {
      resp = await _openPagePermissionGallery(context);
    }

    if (status.isDenied) {
      resp = await _openPagePermissionGallery(context);
    }

    if ((resp != null && resp) || status.isGranted) {
      return true;
    }
    return false;
  }

  Future<Null> _confirmOpenSettings(message, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            content: Text(
                'Los permisos han sido denegados ¿desea abrir la configuración para poder habilitarlos?',
                textAlign: TextAlign.left),
            actions: <Widget>[
              RaisedButton(
                color: Colors.red,
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                color: accentColor,
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _openPagePermissionCamera(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PermissionCameraPage()),
    );
  }

  _openPagePermissionGallery(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PermissionGalleryPage()),
    );
  }

  Widget _switchDisponibility() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: productBlocProvider.productAvailableStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      productModel.isAvailable ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                }),
            SizedBox(
              width: 8.0,
            ),
            _switchStreamBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _switchStreamBuilder() {
    return StreamBuilder(
      stream: productBlocProvider.productAvailableStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // print(MerchantPreferences().isOpen);
        return Switch(
            value: !snapshot.hasData && snapshot.data == null
                ? productModel.isAvailable
                : snapshot.data,
            activeColor: colorSuccess,
            onChanged: (bool value) {
              productBlocProvider.changeProductAvailable(value);
              // print(bloc.productAvailable);
            });
      },
    );
  }

  Widget _productName() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: productBlocProvider.productNameStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return TextFormField(
                initialValue: productModel.name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  errorText: snapshot.error,
                ),
                onChanged: (value) {
                  productBlocProvider.changeProductName(value);
                });
          },
        ),
      ),
    );
  }

  Widget _productPrice() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder(
          stream: productBlocProvider.productPriceStream,
          builder: (context, snapshot) {
            return TextFormField(
              initialValue: productModel.price.toStringAsFixed(2),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(),
                  labelText: 'Precio',
                  errorText: snapshot.error),
              onChanged: (value) {
                productBlocProvider.changeProductPrice(double.parse(value));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _showListMenuCategories() {
    return StreamBuilder<List<MenuCategoriesModel>>(
      stream: productBlocProvider.listMenuCategoriesStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _showItemMenuCategories(snapshot.data[index], index),
              childCount: snapshot.data.length,
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[100],
            child: _itemSkeleton(),
          ),
        );
      },
    );
  }

  Widget _showItemMenuCategories(
      MenuCategoriesModel menuCaregory, int category) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 20, right: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              menuCaregory.name,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          _showListOptions(menuCaregory.options, menuCaregory),
        ],
      ),
    );
  }

  Widget _showListOptions(
      List<OptionsModel> options, MenuCategoriesModel menu) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) => _itemOption(options[index], menu),
    );
  }

  Widget _itemOption(OptionsModel option, MenuCategoriesModel menu) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(option.name),
        StreamBuilder<bool>(
          stream: productBlocProvider.optionAvailableStream,
          builder: (context, snapshot) {
            return Switch(
              value: snapshot.hasData ? snapshot.data : true,
              activeColor: colorSuccess,
              onChanged: (bool value) {
                productBlocProvider.changeStatusOption(option, menu, value);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _customFloating(BuildContext context) {
    return StreamBuilder<bool>(
      stream: productBlocProvider.showLoaderStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FloatingActionButton.extended(
              backgroundColor:
                  snapshot.hasData && snapshot.data ? Colors.grey : accentColor,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Guardar datos', style: textStyleBtnComprar),
                  Visibility(
                    visible: snapshot.hasData && snapshot.data,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onPressed: snapshot.hasData && snapshot.data
                  ? null
                  : () => _updateProduct(context)),
        );
      },
    );
  }

  void _updateProduct(BuildContext context) async {
    productModel.name = productBlocProvider.productName;
    productModel.price = productBlocProvider.productPrice;
    productModel.isAvailable = productBlocProvider.productAvailable;
    productModel.menuCategories = productBlocProvider.listMenuCategories;
    print(productModel.menuCategories[0].options[0].name);
    print(productModel.menuCategories[0].options[0].isAvailable);
    print(productModel.menuCategories[0].options[1].name);
    print(productModel.menuCategories[0].options[1].isAvailable);
    if (productModel.name.isEmpty || productModel.price == null) {
      _scaffoldKey.currentState.showSnackBar(
          _createSnackBar(Colors.red, 'Rellena los campos vacios.'));
    }
    final response =
        await productBlocProvider.updateProduct(product: productModel);
    if (response['ok']) {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        productBlocProvider.changeShowLoader(false);
        productBlocProvider.getProducts();
        Navigator.pop(context);
      });
    } else {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.red, response['message']))
          .closed
          .then((value) {
        productBlocProvider.changeShowLoader(false);
        Navigator.pop(context);
      });
    }
  }

  _createSnackBar(Color color, String message) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: color,
    );
  }

  Widget _itemSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _listItemSkeleton(),
      ),
    );
  }

  List<Widget> _listItemSkeleton() {
    List listings = List<Widget>();
    for (int i = 0; i < 5; i++) {
      listings.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 65.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
