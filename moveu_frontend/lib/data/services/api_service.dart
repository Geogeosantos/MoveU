import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base URL da sua API Django
const String baseUrl = 'http://192.168.100.14:8000/api/users/';

/// ----------------------------
/// Função: Registrar usuário
/// Retorna o token JWT se sucesso
/// ----------------------------
Future<String?> registerUser({
  required String nome,
  required String email,
  required String telefone,
  required String senha,
}) async {
  final url = Uri.parse('${baseUrl}register/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': nome, // campo que o Django espera
        'email': email,
        'phone_number': telefone, // campo que o Django espera
        'password': senha, // campo que o Django espera
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data['access']);
      print(response.statusCode);
      return data['access']; // ou 'access' se você estiver usando JWT padrão
    } else {
      print(
        'Erro ao registrar usuário: ${response.statusCode} | ${response.body}',
      );
      return null;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return null;
  }
}

/// ----------------------------
/// Função: Registrar perfil de motorista
/// ----------------------------
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

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "cnh": cnh,
        "validade_cnh": validadeCnh,
        "categoria_cnh": categoriaCnh,
        "modelo_carro": modeloCarro,
        "placa_carro": placaCarro,
        "cor_carro": corCarro,
        "ano_carro": anoCarro,
      }),
    );

    if (response.statusCode == 201) {
      print("Perfil de motorista registrado com sucesso!");
      return true;
    } else {
      print(
        'Erro ao registrar perfil: ${response.statusCode} | ${response.body}',
      );
      return false;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return false;
  }
}

/// ----------------------------
/// Função: Login do usuário
/// Retorna o token JWT
/// ----------------------------
Future<String?> loginUser({
  required String email,
  required String senha,
}) async {
  final url = Uri.parse('${baseUrl}login/');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access']; // token JWT
    } else {
      print('Erro ao logar: ${response.statusCode} | ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return null;
  }
}

/// ----------------------------
/// Função: Obter perfil do usuário
/// ----------------------------
Future<Map<String, dynamic>?> getProfile(String token) async {
  final url = Uri.parse('${baseUrl}profile/');

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Erro ao obter perfil: ${response.statusCode} | ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return null;
  }
}

/// ----------------------------
/// Função: Atualizar perfil do usuário
/// ----------------------------
Future<bool> updateProfile({
  required String token,
  String? nome,
  String? email,
  String? telefone,
}) async {
  final url = Uri.parse('${baseUrl}profile/');

  Map<String, dynamic> body = {};
  if (nome != null) body['username'] = nome;
  if (email != null) body['email'] = email;
  if (telefone != null) body['phone_number'] = telefone;

  try {
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
        'Erro ao atualizar perfil: ${response.statusCode} | ${response.body}',
      );
      return false;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return false;
  }
}

/// ----------------------------
/// Função: Atualizar tipo de usuário
/// ----------------------------
Future<bool> setUserType({
  required String token,
  required String tipo, // "driver" ou "passenger"
}) async {
  final url = Uri.parse('${baseUrl}set_user_type/');

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"type": tipo}),
    );

    if (response.statusCode == 200) {
      print('Tipo de usuário atualizado');
      return true;
    } else {
      print(
        'Erro ao atualizar tipo de usuário: ${response.statusCode} | ${response.body}',
      );
      
      return false;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return false;
  }
}


/// ----------------------------
/// Função: Cadastrar horário do usuário
/// ----------------------------
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
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "day": day,
        "start_time": startTime,
        "end_time": endTime,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Horário do $day cadastrado com sucesso');
      return true;
    } else {
      print('Erro ao cadastrar horário: ${response.statusCode} | ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erro de conexão ao cadastrar horário: $e');
    return false;
  }
}
