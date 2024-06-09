import 'package:dio/dio.dart';

class API {
  final Dio dio = Dio();
  final String baseUrl = "https://kendim yazmaya zamanımda bilgimde yoktu/api";
  login({
    required String email,
    required String password,
  }) async {
    try {
      final String endpoint = "$baseUrl/login";

      final params = {
        "email": email,
        "password": password,
      };

      final response = await dio.post(endpoint, data: FormData.fromMap(params));

      return response.data;
    } catch (e) {
      return e;
    }
  }

  register({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      final String endpoint = "$baseUrl/login";

      final params = {
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "password_confirmation": password,
      };

      final response = await dio.post(endpoint, data: FormData.fromMap(params));

      return response.data;
    } catch (e) {
      return e;
    }
  }
  /*
  getPrograms() async {
    try {
      final String endpoint = "$baseUrl/programs";

      final response = await dio.post(endpoint);

      return response.data;
    } catch (e) {
      return e;
    }
  }
  */
}
