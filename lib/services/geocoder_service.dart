import 'dart:convert';

import 'package:http/http.dart' as http;
class GeocoderService{
  String baseURL = "http://api.openweathermap.org/geo/1.0/";
  String apiKey = "959d1296a89c3365a20b001a440c4eb3";

  Future<String?> getAddressFromCoordinates({required double latitude, required double longitude}) async{
    String completeUrl = "${baseURL}reverse?lat=${latitude}&lon=${longitude}&limit=1&appid=${apiKey}";
    final response = await http.get(
      Uri.parse(completeUrl),
      headers: {
        'Content-Type':'application/json'
      }
    );

    if(response.statusCode == 200){
      List<dynamic> json = jsonDecode(response.body);
      return json.first["name"];
    }
    return null;
  }
}