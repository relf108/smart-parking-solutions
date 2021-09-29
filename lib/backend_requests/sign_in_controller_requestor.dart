import 'dart:io';

import 'package:http/http.dart';
import 'package:smart_parking_solutions/backend_requests/rest_details.dart';

class SignInControllerRequestor {
  var email;
  var password;
  SignInControllerRequestor({required this.email, required this.password});

  ///Return available spaces within distance around coordinates (JSON object)
  Future<Response> attemptLogin() async {
    final client =
        HttpClient(); // Todo client intialization in class constructor or pass throught constructor
    final uri = Uri.parse(
        'http://192.168.1.111:8888/signInUser?email=$email&password=$password');
    //HttpClientResponse httpResult;
    final Response response = await get(uri);
    return response;
  }
}
