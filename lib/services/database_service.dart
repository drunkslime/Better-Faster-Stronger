import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;


var logger = Logger();

class DatabaseService {
  
  Future<http.Response> getResponse(var value) async {
    var url1 = Uri.http('26.136.164.153:8000', '/accessor/exercises/', {'name__startswith': value}); 
    var response = await http.get(url1);
    if (response.statusCode == 200) {
      return response;
    }
    var url2 = Uri.http('192.168.1.216:8000', '/accessor/exercises/', {'name': value});
    response = await http.get(url2);
    if (response.statusCode == 200) {
      return response;
    }
    throw Exception('''
      Destination not reached.\n
      value: ${value}\n
      url1: ${url1}\n
      url2: ${url2}\n
      response.statusCode: ${response.statusCode}\n
      response.body: ${response.body}\n
    ''');
  }
}