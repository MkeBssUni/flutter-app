import 'dart:convert';

import 'package:flutter_app_10_a/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  //local storage
/* import 'package:flutter_app_10_a/models/user.dart'; */
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000/api'; // de emulador al pc
  // en caso de usar dispositivo físico, apuntar al ip del pc

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/login'),
          headers: <String, String>{
            //headers separados por comas
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'email': email, 'password': password}));

          String bodyRequest = jsonEncode({'email': email, 'password': password});
          print("bodyRequest: $bodyRequest");
          //

          if(response.statusCode == 200){
            print("pasaleeee: $response");

            Map<String, dynamic> responseData = jsonDecode(response.body);
            return {'success': true, 'data':responseData};
          }else{
            print("Pilas, no te topo");
            return {'success': false, 'message':'Algo salío mal'};
          }
    } catch (e) {
      print("Valiendo cheto en auth service hehe: $e");
      return {'success': false, 'message':'Algo salío mal'};
    }
  }
  
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    print("nombre $name");
    print("email $email");
    print("password $password");
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/register'),
          headers: <String, String>{
            //headers separados por comas
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'name':name,'email': email, 'password': password}));

          int statusCode = response.statusCode;
          print("statusCode: $statusCode");

          if(response.statusCode == 200 || response.statusCode == 201){
            print("registrado: $response");

            Map<String, dynamic> responseData = jsonDecode(response.body);

            return {'success': true, 'data':responseData};
          }else{
            print("Pilas, no te topo");
            return {'success': false, 'message':'Algo salío mal'};
          }
    } catch (e) {
      print("Valiendo cheto en auth register hehe: $e");
      return {'success': false, 'message':'Algo salío mal'};
    }
  }

  Future<void> saveUser(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('jwt', user.token);
    preferences.setString('name', user.name);
    preferences.setString('email', user.email);
    preferences.setString('id', user.id);
  }

  Future<User?> getUser () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final id = preferences.getString('id');
    final name = preferences.getString('name');
    final email = preferences.getString('email');
    final jwt = preferences.getString('jwt');

    if(id != null && name != null && email != null && jwt != null){
      return User(id: id, name: name, email: email, token: jwt);
    }

    return null;
  }

  Future<void> removeUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('jwt');
    preferences.remove('name');
    preferences.remove('email');
    preferences.remove('id');
  }

  // Validate token
  Future<bool> validateToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jwt = preferences.getString('jwt');

    if(jwt == null){
      return false;
    }
    try{
      final jwtParser = JWT.decode(jwt);
      final exp = jwtParser.payload['exp']<DateTime.now().millisecondsSinceEpoch/1000;
    
      if(exp){
        return false;
      }else{
        removeUser();
        return true;
      }
    }catch(e){
      return false;
    }
  }
}
