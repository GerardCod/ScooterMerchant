import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}

Map<String, dynamic> parseJwtPayLoad(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

void showSnackBar(BuildContext context, String message, Color colorBackground) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: textStyleSnackBar,
    ),
    backgroundColor: colorBackground,
  );

  Scaffold.of(context).showSnackBar(snackBar);
}

void showAlert(BuildContext context, String titulo, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Avira', fontSize: 22),
          ),
          content: Text(
            mensaje,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: accentColor,
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Navigator.pop(context);
              },
            )
          ],
        );
      });
}
