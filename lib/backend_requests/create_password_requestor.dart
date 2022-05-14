import 'dart:convert';

import 'package:http/http.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/tmp/session_data.dart';

class CreatePasswordController {
  CreatePasswordController();

  ///Return available spaces within distance around coordinates (JSON object)
  Future<Response> setPass(String newPass) async {
    final uri =
        Uri.parse("http://" + localhost + ":8888/changePassword?password=$newPass");
    //HttpClientResponse httpResult;
    final Response response = await post(uri,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(SessionData.currentUser.toJson()));
    return response;
  }
}
