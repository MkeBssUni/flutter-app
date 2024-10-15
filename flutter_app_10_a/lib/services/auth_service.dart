import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  //local storage
/* import 'package:flutter_app_10_a/models/user.dart'; */

class AuthService {
  final String baseUrl = '10.0.2.2:5000/api'; // de emulador al pc
  // en caso de usar dispositivo físico, apuntar al ip del pc

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/login'),
          headers: <String, String>{
            //headers separados por comas
            'ContentType': 'application/json',
          },
          body: jsonEncode({'email': email, 'password': password}));

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
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/register'),
          headers: <String, String>{
            //headers separados por comas
            'ContentType': 'application/json',
          },
          body: jsonEncode({'name':name,'email': email, 'password': password}));

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

  Future<void> saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('jwt', token);
  }

  Future<String?> getToken () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('jwt');
  }

  Future<void> removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('jwt');
  }
}
