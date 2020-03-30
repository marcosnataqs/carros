import 'dart:convert';
import 'dart:io';
import 'package:carros/domain/user.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'package:carros/domain/response.dart';

class LoginService {
  static Future<Response> login(String login, String senha) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return Response(
          false, "Internet insdisponível. Por favor, verifique sua conexão");
    }

    try {
      var url = 'http://livrowebservices.com.br/rest/login';
      final response =
          await http.post(url, body: {'login': login, 'senha': senha});

      final s = response.body;
      print(s);

      final r = Response.fromJson(json.decode(s));

      if (r.isOk()) {
        final user = User("Marcos Santos", login, "marcos.santos@flutter.com");
        user.save();
      }

      return r;
    } catch (error) {
      return Response(false, handleError(error));
    }
  }

  static String handleError(error) {
    return error is SocketException
        ? "Internet insdisponível. Por favor, verifique sua conexão"
        : "Ocorreu um erro no login";
  }
}
