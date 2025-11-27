import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/api_service.dart'; // <- voltou

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  int? selectedCity;
  int? selectedNeighborhood;
  int? selectedUniversity;
  String? selectedGender;

  // 🔽 Listas locais (sem API)
  List<Map<String, dynamic>> cities = [
    {"id": 1, "name": "SALVADOR"},
  ];

  List<Map<String, dynamic>> neighborhoods = [
    {"id": 1, "name": "CENTRO"},
    {"id": 2, "name": "ITAIGARA"},
    {"id": 3, "name": "RIO VERMELHO"},
  ];

  List<Map<String, dynamic>> universities = [
    {"id": 3, "name": "UFBA", "city_id": 1},
    {"id": 2, "name": "UNIFTC", "city_id": 1},
    {"id": 1, "name": "UNIJORGE", "city_id": 1},
  ];

  bool isLoading = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  // 🔥 Agora registra de verdade no banco!
  Future<void> registrarUsuario() async {
    if (selectedCity == null ||
        selectedNeighborhood == null ||
        selectedGender == null ||
        selectedUniversity == null ||
        nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        telefoneController.text.isEmpty ||
        senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos!")),
      );
      return;
    }

    setState(() => isLoading = true);

    final token = await registerUser(
      username: nomeController.text,
      email: emailController.text,
      phoneNumber: telefoneController.text,
      password: senhaController.text,
      city: selectedCity!,
      neighborhood: selectedNeighborhood!,
      university: selectedUniversity!,
      gender: selectedGender!,
    );

    setState(() => isLoading = false);

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário registrado com sucesso!")),
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.userSchedule,
        arguments: token,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao registrar usuário")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            const Text(
              'Registro de Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF352555),
                fontFamily: 'Quicksand',
              ),
            ),
            const SizedBox(height: 30),

            // Inputs
            buildInput("Nome", nomeController),
            buildInput("Email", emailController),
            buildInput("Telefone", telefoneController),
            buildInput("Senha", senhaController, obscure: true),
            const SizedBox(height: 15),

            buildDropdownGender(),
            const SizedBox(height: 15),
            buildDropdownUniversities(),
            const SizedBox(height: 15),
            buildDropdownCities(),
            const SizedBox(height: 15),
            buildDropdownNeighborhoods(),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: isLoading ? null : registrarUsuario,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40B59F),
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Adicionar perfil",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ========= UI HELPERS =========

  InputDecoration inputDecor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  Widget buildInput(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: inputDecor(label),
      ),
    );
  }

  Widget buildDropdownGender() {
    return DropdownButtonFormField<String>(
      decoration: inputDecor("Sexo"),
      value: selectedGender,
      items: const [
        DropdownMenuItem(value: "M", child: Text("Masculino")),
        DropdownMenuItem(value: "F", child: Text("Feminino")),
      ],
      onChanged: (v) => setState(() => selectedGender = v),
    );
  }

  Widget buildDropdownUniversities() {
    return DropdownButtonFormField<int>(
      decoration: inputDecor("Faculdade"),
      value: selectedUniversity,
      items: universities
          .map((u) => DropdownMenuItem<int>(
                value: u["id"] as int,
                child: Text(u["name"]),
              ))
          .toList(),
      onChanged: (v) => setState(() => selectedUniversity = v),
    );
  }

  Widget buildDropdownCities() {
    return DropdownButtonFormField<int>(
      decoration: inputDecor("Cidade"),
      value: selectedCity,
      items: cities
          .map((c) => DropdownMenuItem<int>(
                value: c["id"] as int,
                child: Text(c["name"]),
              ))
          .toList(),
      onChanged: (v) {
        setState(() {
          selectedCity = v;
          selectedNeighborhood = null;
        });
      },
    );
  }

  Widget buildDropdownNeighborhoods() {
    return DropdownButtonFormField<int>(
      decoration: inputDecor("Bairro"),
      value: selectedNeighborhood,
      items: neighborhoods
          .map((b) => DropdownMenuItem<int>(
                value: b["id"] as int,
                child: Text(b["name"]),
              ))
          .toList(),
      onChanged: (v) => setState(() => selectedNeighborhood = v),
    );
  }
}
