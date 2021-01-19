import "dart:async";
import "package:http/http.dart" show Client;
import 'dart:convert';
import "package:Todoapp/models/classes/user.dart";

class ApiProvider {
  Client client = Client();
  final _apiKey = 'njfc';

  Future<User> registerUser(String username, String firstname, String lastname,
      String password, String email) async {
    print(3);
    final response = await client.post("https://10.0.2.2:6010/api/register",
        // headers: "",
        body: jsonEncode({
          "emailadress": email,
          "username": username,
          "password": password,
          "firstname": firstname,
          "lastname": lastname
        }));
    print(22);
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      print(32);
      return User.fromJson(result['data']);
    } else {
      throw Exception("Failed to load post");
    }
  }
}
