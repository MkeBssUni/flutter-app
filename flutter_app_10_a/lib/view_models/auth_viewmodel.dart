import 'package:flutter/material.dart';
import 'package:flutter_app_10_a/models/user.dart';
import 'package:flutter_app_10_a/services/auth_service.dart';

class AuthViewmodel extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _message;

  User? get user => _user;
  bool? get loading => _loading;
  String? get message => _message;

  final AuthService authService = AuthService();

  Future<void> login (String email, String password) async {
    _loading = true;
    _message = null;
    notifyListeners();

    final response = await authService.login(email, password);
    if(response['success']){
      _user = User.fromJson(response['data']);
      await authService.saveUser(_user!);
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
      await authService.saveUser(_user!);
    }else{
      _message=response['message'];
    }
    _loading=false;
    notifyListeners();
  }

  Future<void> logOut() async{  
    authService.removeUser();
    _user = null;
    notifyListeners();
  }

  Future<void> checkSession () async{
    final User? user = await authService.getUser();
    user != null ? (
      _user = user,
      _message='User exists'
    ) : (
      _user = null,
      _message="User doesn't exists"
    );
  }

  Future<bool> validateToken() async {
    return await authService.validateToken();
  }
}