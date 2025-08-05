import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  
  final address = kReleaseMode ? 'bfserver-two.vercel.app' : '26.136.164.153:8000';
  
  Future<http.Response> getResponse(var httpUrl) async {
    var url = httpUrl; 
    var response = await http.get(url);
    Logger().i("Request url: $url \nStatus Code: ${response.statusCode} \nBody: ${response.body}");
    return response;
  }
}

