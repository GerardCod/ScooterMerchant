class AuthModel {
  String username;
  String password;

  AuthModel({this.username, this.password});

  Map<String, String> toMap() {
    return {'username': username, 'password': password};
  }
}
