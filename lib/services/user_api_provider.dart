
import 'package:http/http.dart' as http;

class UserProvider {
  // http://jsonplaceholder.typicode.com/users

  Future<String> sendOtpCode() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.https('api.choparpizza.uz', '/api/keldi');
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {

    }

    return '';
  }

  // Future<List<User>> getUser() async {
  //   final response = await http.get('http://jsonplaceholder.typicode.com/users');
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> userJson = json.decode(response.body);
  //     return userJson.map((json) => User.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Error fetching users');
  //   }
  // }
}