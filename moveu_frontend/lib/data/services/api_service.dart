import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base URL da API
const String baseUrl = 'http://10.0.2.2:8000/api/users/';

/// Headers padrão (quando não precisa token)
Map<String, String> defaultHeaders = {"Content-Type": "application/json"};

/// Headers quando precisa de autenticação
Map<String, String> authHeaders(String token) => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
};

/// =================================================
/// REGISTER USER
/// =================================================
Future<String?> registerUser({
  required String username,
  required String email,
  required String phoneNumber,
  required String password,
  required int city,
  required int neighborhood,
  required int university,
  required String gender,
}) async {
  final url = Uri.parse('${baseUrl}register/');

  final body = jsonEncode({
    "username": username,
    "email": email,
    "phone_number": phoneNumber,
    "password": password,
    "city": city,
    "neighborhood": neighborhood,
    "university": university,
    "gender": gender,
  });

  try {
    final response = await http.post(url, headers: defaultHeaders, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['access'];
    }

    print("Register error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print('Connection error (Register): $e');
    return null;
  }
}

/// =================================================
/// REGISTER DRIVER PROFILE
/// =================================================
Future<bool> registerDriverProfile({
  required String token,
  required String cnh,
  required String validadeCnh,
  required String categoriaCnh,
  required String modeloCarro,
  required String placaCarro,
  required String corCarro,
  required int anoCarro,
}) async {
  final url = Uri.parse('${baseUrl}register_driver_profile/');

  final body = jsonEncode({
    "cnh": cnh,
    "validade_cnh": validadeCnh,
    "categoria_cnh": categoriaCnh,
    "modelo_carro": modeloCarro,
    "placa_carro": placaCarro,
    "cor_carro": corCarro,
    "ano_carro": anoCarro,
  });

  try {
    final response = await http.post(
      url,
      headers: authHeaders(token),
      body: body,
    );

    if (response.statusCode == 201) return true;

    print("Driver profile error: ${response.statusCode} | ${response.body}");
    return false;
  } catch (e) {
    print("Connection error (DriverProfile): $e");
    return false;
  }
}

/// =================================================
/// LOGIN USER
/// =================================================
Future<String?> loginUser({
  required String email,
  required String senha,
}) async {
  final url = Uri.parse('${baseUrl}login/');

  try {
    final response = await http.post(
      url,
      headers: defaultHeaders,
      body: jsonEncode({"email": email, "password": senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access'];
    }

    print("Login error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Login): $e");
    return null;
  }
}

/// =================================================
/// GET PROFILE
/// =================================================
Future<Map<String, dynamic>?> getProfile(String token) async {
  final url = Uri.parse('${baseUrl}profile/');

  try {
    final response = await http.get(url, headers: authHeaders(token));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    print("Profile error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Profile): $e");
    return null;
  }
}

/// =================================================
/// UPDATE PROFILE
/// =================================================
Future<bool> updateProfile({
  required String token,
  String? nome,
  String? email,
  String? telefone,
}) async {
  final url = Uri.parse('${baseUrl}profile/');

  final body = {
    if (nome != null) "username": nome,
    if (email != null) "email": email,
    if (telefone != null) "phone_number": telefone,
  };

  try {
    final response = await http.put(
      url,
      headers: authHeaders(token),
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  } catch (e) {
    print("Connection error (Update Profile): $e");
    return false;
  }
}

/// =================================================
/// SET USER TYPE
/// =================================================
Future<bool> setUserType({
  required String token,
  required String tipo, // "driver" ou "passenger"
}) async {
  final url = Uri.parse('${baseUrl}set_user_type/');

  try {
    final response = await http.post(
      url,
      headers: authHeaders(token),
      body: jsonEncode({"type": tipo}),
    );

    return response.statusCode == 200;
  } catch (e) {
    print("Connection error (User Type): $e");
    return false;
  }
}

/// =================================================
/// SET USER SCHEDULE
/// =================================================
Future<bool> setUserSchedule({
  required String token,
  required String day,
  required String startTime,
  required String endTime,
}) async {
  final url = Uri.parse('${baseUrl}set_user_schedule/');

  try {
    final response = await http.post(
      url,
      headers: authHeaders(token),
      body: jsonEncode({
        "day": day,
        "start_time": startTime,
        "end_time": endTime,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print("Connection error (Schedule): $e");
    return false;
  }
}

/// =================================================
/// GET CITIES
/// =================================================
Future<List<Map<String, dynamic>>?> getCities() async {
  final url = Uri.parse('${baseUrl}cities/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }

    print("Cities error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Cities): $e");
    return null;
  }
}

/// =================================================
/// GET UNIVERSITIES
/// =================================================
Future<List<Map<String, dynamic>>?> getUniversities() async {
  final url = Uri.parse('${baseUrl}universities/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }

    print("Universities error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Universities): $e");
    return null;
  }
}

/// =================================================
/// GET NEIGHBORHOODS BY CITY
/// =================================================
Future<List<Map<String, dynamic>>?> getNeighborhoods(int cityId) async {
  final url = Uri.parse('${baseUrl}neighborhoods/$cityId/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }

    print("Neighborhoods error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Neighborhoods): $e");
    return null;
  }
}
