import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

const String baseUrl = 'http://10.0.2.2:8000/api/';

Map<String, String> defaultHeaders = {"Content-Type": "application/json"};

Map<String, String> authHeaders(String token) => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
};

Future<String?> registerUser({
  required String username,
  required String email,
  required String phoneNumber,
  required String password,
  required int city,
  required int neighborhood,
  required int university,
  required String gender,
  required int age,
  File? photo,
}) async {
  final url = Uri.parse('${baseUrl}users/register/');

  var request = http.MultipartRequest('POST', url);

  request.fields['username'] = username;
  request.fields['email'] = email;
  request.fields['phone_number'] = phoneNumber;
  request.fields['password'] = password;
  request.fields['city'] = city.toString();
  request.fields['neighborhood'] = neighborhood.toString();
  request.fields['university'] = university.toString();
  request.fields['gender'] = gender;
  request.fields['age'] = age.toString();

  if (photo != null) {
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
  }

  try {
    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final data = jsonDecode(body);
      return data['access'];
    }

    print("Register error: ${response.statusCode} | $body");
    return null;
  } catch (e) {
    print('Connection error (Register): $e');
    return null;
  }
}

Future<String?> loginUser({
  required String email,
  required String senha,
}) async {
  final url = Uri.parse('${baseUrl}users/login/');

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

Future<Map<String, dynamic>?> getProfile(String token) async {
  final url = Uri.parse('${baseUrl}users/profile/');

  try {
    final response = await http.get(url, headers: authHeaders(token));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        return body;
      } else {
        print("Profile response is not a valid object: $body");
        return null;
      }
    }

    print("Profile error: ${response.statusCode} | ${response.body}");
    return null;
  } catch (e) {
    print("Connection error (Profile): $e");
    return null;
  }
}

Future<bool> updateProfile({
  required String token,
  String? nome,
  String? email,
  String? telefone,
}) async {
  final url = Uri.parse('${baseUrl}users/profile/');

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

Future<bool> setUserType({
  required String token,
  required String tipo,
}) async {
  final url = Uri.parse('${baseUrl}users/set_user_type/');

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
  final url = Uri.parse('${baseUrl}users/register_driver_profile/');

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

Future<bool> setUserSchedule({
  required String token,
  required String day,
  required String startTime,
  required String endTime,
}) async {
  final url = Uri.parse('${baseUrl}users/set_user_schedule/');

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

Future<List<Map<String, dynamic>>> getAvailableDrivers(String token) async {
  final url = Uri.parse('${baseUrl}rides/available_drivers/');

  try {
    final response = await http.get(url, headers: authHeaders(token));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }

    print("Get drivers error: ${response.statusCode} | ${response.body}");
    return [];
  } catch (e) {
    print("Connection error (Drivers): $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> getReceivedRideRequests(String token) async {
  final url = Uri.parse('${baseUrl}rides/received_rides/');

  try {
    final response = await http.get(url, headers: authHeaders(token));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    print("Get ride requests error: ${response.statusCode} | ${response.body}");
    return [];
  } catch (e) {
    print("Connection error (Ride Requests): $e");
    return [];
  }
}

Future<bool> postRideStatus({
  required String token,
  required int rideId,
  required String status,
  String? reason,
}) async {
  final url = Uri.parse('${baseUrl}rides/ride_status/$rideId/');

  final body = {"status": status, if (reason != null) "reason": reason};

  try {
    final response = await http.post(
      url,
      headers: authHeaders(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) return true;

    print(
      "Error updating ride status: ${response.statusCode} | ${response.body}",
    );
    return false;
  } catch (e) {
    print("Connection error (Ride Status): $e");
    return false;
  }
}

Future<List<Map<String, dynamic>>> getRideHistory(String token) async {
  final url = Uri.parse(
    '${baseUrl}rides/ride_history/',
  );

  try {
    final response = await http.get(url, headers: authHeaders(token));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }

    print("Get ride history error: ${response.statusCode} | ${response.body}");
    return [];
  } catch (e) {
    print("Connection error (Ride History): $e");
    return [];
  }
}
