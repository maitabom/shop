import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/errors/auth_exception.dart';

class Auth with ChangeNotifier {
  final String _baseUrl = dotenv.env['FIREBASE_BASE_URL'] ?? '';
  final String _key = dotenv.env['FIREBASE_API_KEY'] ?? '';

  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expireDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _uid : null;
  }

  Future<void> signUp(String email, String password) async {
    final String fragment = 'signUp';

    return _authenticate(email, password, fragment);
  }

  Future<void> login(String email, String password) async {
    final String fragment = 'signInWithPassword';

    return _authenticate(email, password, fragment);
  }

  void logout() {
    _token = null;
    _email = null;
    _uid = null;
    _expireDate = null;

    _clearAutoLogoutTimer();

    Store.remove('userData').then((_) => notifyListeners());
  }

  Future<void> autologin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _uid = userData['userId'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();

    final timeExpire = _expireDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeExpire ?? 0), logout);
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String fragment,
  ) async {
    final url = '$_baseUrl:$fragment?key=$_key';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message'] ?? '');
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];

      _expireDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _uid,
        'expireDate': _expireDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }
}
