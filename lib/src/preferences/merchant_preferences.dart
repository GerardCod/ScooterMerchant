import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scootermerchant/src/models/merchant_model.dart';

class MerchantPreferences {
  static final MerchantPreferences _instance =
      new MerchantPreferences._internal();

  factory MerchantPreferences() {
    return _instance;
  }

  MerchantPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  set removeKey(String key) {
    this._prefs.remove(key);
  }

  get access {
    return this._prefs.get('access') ?? null;
  }

  set access(String accessToken) {
    this._prefs.setString('access', accessToken);
  }

  get refresh {
    return this._prefs.get('refresh') ?? null;
  }

  set refresh(String refresh) {
    this._prefs.setString('refresh', refresh);
  }

  get merchant {
    return this._prefs.get('merchant') ?? null;
  }

  set merchant(MerchantModel merchant) {
    this._prefs.setString('merchant', json.encode(merchant));
  }
}
