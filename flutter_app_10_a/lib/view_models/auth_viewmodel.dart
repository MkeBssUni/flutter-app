import 'package:flutter/material.dart';
import 'package:flutter_app_10_a/models/user.dart';
import 'package:flutter_app_10_a/services/auth_service.dart';

class AuthViewmodel extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _message;

  User? get user => user;
  bool? get loading => loading;
  String? get message => message;

  final AuthService authService = AuthService();

  Future<void> login (String email, String password) async {
    _loading = true;
    _message = null;
    notifyListeners();

    final response = await authService.login(email, password);
    if(response['success']){
      _user = User.fromJson(response['data']);
      await authService.saveToken(_user!.token);
    }else{
      _message=response['message'];
    }
    _loading=false;
    notifyListeners();
  }
  
  Future<void> register (String name, String email, String password) async {
    _loading = true;
    _message = null;
    notifyListeners();

    final response = await authService.register(name, email, password);
    if(response['success']){
      _user = User.fromJson(response['data']);
      await authService.saveToken(_user!.token);
    }else{
      _message=response['message'];
    }
    _loading=false;
    notifyListeners();
  }

  Future<void> logOut() async{
    authService.removeToken();
    _user = null;
    notifyListeners();
  }

  Future<void> checkSession () async{
    final String? token = await authService.getToken();
    token != null ? (
      _message='Token exists'
    ) : _message="Token doesn't exists";
  }
}