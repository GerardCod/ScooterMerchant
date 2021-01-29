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

class ProductImagePage extends StatelessWidget {
  ProductModel productModel;
  ProductImagePage({this.productModel});
  

  ProductBlocProvider productBlocProvider;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    productBlocProvider = Provider.productBlocProviderOf(context);

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
        Navigator.pop(context);
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
        Navigator.pop(context);
      }
    }
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
}
