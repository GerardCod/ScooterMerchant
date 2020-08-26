import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (String data, EventSink<String> sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(data)) {
      sink.add(data);
    } else {
      sink.addError('El correo es inválido.');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (String data, EventSink<String> sink) {
    if (data.length >= 8) {
      sink.add(data);
    } else {
      sink.addError('La contraseña debe tener mínimo 8 caracteres.');
    }
  });

  final validateRejectReason = StreamTransformer<String, String>.fromHandlers(
      handleData: (String data, EventSink<String> sink) {
    if (data.length > 0) {
      sink.add(data);
    } else {
      sink.addError('Escriba por qué rechaza este pedido.');
    }
  });
}
