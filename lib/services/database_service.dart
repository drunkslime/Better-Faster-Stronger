import 'package:http/http.dart' as http;

class DatabaseService {

  // final address = '192.168.1.250:8000';
  // final address = '10.0.0.107:8000'; 
  final address = '26.136.164.153:8000';
  
  Future<http.Response> getResponse(var httpUrl) async {
    var url = httpUrl; 
    var response = await http.get(url);
    return response;
  }
}
