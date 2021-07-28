import 'dart:io';

import 'package:smart_parking_solutions/backend_requests/rest_details.dart';

class SignInControllerRequestor {
  var email;
  var password;
  SignInControllerRequestor({required this.email, required this.password});

  ///Return available spaces within distance around coordinates (JSON object)
  Future<HttpClientResponse> attemptLogin() async {
    final client =
        HttpClient(); // Todo client intialization in class constructor or pass throught constructor
    final uri = Uri.parse(
        "${RestDetails.host}/signInUser?email=$email &password=$password");
    //HttpClientResponse httpResult;
    final HttpClientRequest req = await client.getUrl(uri);
    final response = (await req.close());

    return response;
  }
}
