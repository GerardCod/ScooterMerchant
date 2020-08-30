import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/auth_model.dart';
import 'package:scootermerchant/src/providers/login_provider.dart';

class LoginBloc with Validators {
  final _provider = LoginProvider();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();

  Future<Map<String, dynamic>> login(AuthModel model) async {
    return await _provider.login(model);
  }

  Future<bool> logout() async {
    return await _provider.logout();
  }

  Future<Map<String, dynamic>> forgotPassword({@required String email}) async {
    return await _provider.forgotPassword(email: email);
  }

  Future<Map<String, dynamic>> updatePassword(
      {@required String password, @required String token}) async {
    return await _provider.changePassword(password: password, token: token);
  }

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<String> get confirmPasswordStream =>
      _confirmPasswordController.stream.transform(validatePassword);

  Stream<bool> get comparePasswordsStream => Rx.combineLatest2(
      passwordStream, confirmPasswordStream, (String a, String b) => a == b);

  Stream<bool> get validationStream =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get confirmPassword => _confirmPasswordController.value;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword =>
      _confirmPasswordController.sink.add;

  dispose() {
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
}
