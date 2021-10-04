import 'package:http/http.dart';

class SignInControllerRequestor {
  var email;
  var password;
  SignInControllerRequestor({required this.email, required this.password});

  ///Return available spaces within distance around coordinates (JSON object)
  Future<Response> attemptLogin() async {
    final uri = Uri.parse(
        'http://192.168.1.111:8888/signInUser?email=$email&password=$password');
    //HttpClientResponse httpResult;
    final Response response = await get(uri);
    return response;
  }
}
