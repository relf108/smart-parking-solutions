import 'dart:convert';
import 'dart:io';

import 'package:smart_parking_solutions/backend_requests/rest_details.dart';

class ParkingControllerRequestor {
  var lat;
  var long;
  var distance;
  ParkingControllerRequestor({required lat, required long, required distance});

  ///Return available spaces within distance around coordinates (JSON object)
  Future<String> getSpaces() async {
    final client =
        HttpClient(); // Todo client intialization in class constructor or pass throught constructor
    final uri = Uri.parse(
        "${RestDetails.host}/parking?lat= $lat &long= $long &distance=$distance");
    //HttpClientResponse httpResult;
    final HttpClientRequest req = await client.getUrl(uri);
    final response = (await req.close()).transform(const Utf8Decoder());
    var respString = '';
    await for (var data in response) {
      // ignore: use_string_buffers
      respString += data;
    }
    return respString;
  }
}
