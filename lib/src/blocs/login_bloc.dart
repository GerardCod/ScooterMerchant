import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get validationStream =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  String get email => _emailController.value;
  String get password => _passwordController.value;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
