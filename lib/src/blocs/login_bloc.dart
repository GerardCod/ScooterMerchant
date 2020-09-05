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
  final _availabilityController = BehaviorSubject<bool>();
  final _showLoaderController = BehaviorSubject<bool>();

  Future<Map<String, dynamic>> login(AuthModel model) async {
    changeShowLoader(true);
    Map<String, dynamic> response = await _provider.login(model);
    changeShowLoader(false);
    return response; 
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

  Future<Map<String, dynamic>> updateAvailability(
      {@required bool isOpen}) async {
    final response = await _provider.updateAvailability(isOpen: isOpen);
    changeAvailability(response['data']);
    return response;
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

  Stream<bool> get availabilityStream => _availabilityController.stream;
  Stream<bool> get showLoaderStream => _showLoaderController.stream;

  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get confirmPassword => _confirmPasswordController.value;
  bool get showLoader => _showLoaderController.value;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword =>
      _confirmPasswordController.sink.add;

  Function(bool) get changeAvailability => _availabilityController.sink.add;
  Function(bool) get changeShowLoader => _showLoaderController.sink.add;

  dispose() {
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _availabilityController.close();
    _showLoaderController.close();
  }
}
