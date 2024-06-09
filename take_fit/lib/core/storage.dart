import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  loadUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var id = storage.getInt("id");
    var name = storage.getString("name");
    var surname = storage.getString("surname");
    var email = storage.getString("e-mail");
    var password = storage.getString("password");

    if (id == null) {
      return null;
    } else {
      return {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password
      };
    }
  }

  saveUser({
    required int id,
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setInt("id", id);
    storage.setString("name", name);
    storage.setString("surname", surname);
    storage.setString("email", email);
    storage.setString("password", password);
  }

  saveToken(String token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "token", value: token);
  }

  loadToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    return token;
  }
}
