import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/api_service.dart';

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
  final TextEditingController idadeController =
      TextEditingController(); // 🆕 Age

  int? selectedCity;
  int? selectedNeighborhood;
  int? selectedUniversity;
  String? selectedGender;

  File? selectedImage; // 🆕 Foto
  bool isLoading = false;

  // 🔽 Dados locais
  List<Map<String, dynamic>> cities = [
    {"id": 1, "name": "SALVADOR"},
    {"id": 2, "name": "FEIRA DE SANTANA"},
  ];

  List<Map<String, dynamic>> neighborhoods = [
    {"id": 1, "name": "SÃO CAETANO"},
    {"id": 2, "name": "CAIXA D'ÁGUA"},
    {"id": 3, "name": "PIATÃ"},
  ];

  List<Map<String, dynamic>> universities = [
    {"id": 3, "name": "UFBA"},
    {"id": 2, "name": "UNIFTC"},
    {"id": 1, "name": "UNIJORGE"},
  ];

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() => selectedImage = File(photo.path));
    }
  }

  Future<void> registrarUsuario() async {
    if (selectedCity == null ||
        selectedNeighborhood == null ||
        selectedGender == null ||
        selectedUniversity == null ||
        nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        telefoneController.text.isEmpty ||
        senhaController.text.isEmpty ||
        idadeController.text.isEmpty) {
      showMsg("Preencha todos os campos");
      return;
    }

    setState(() => isLoading = true);

    final token = await registerUser(
      username: nomeController.text,
      email: emailController.text,
      phoneNumber: telefoneController.text,
      password: senhaController.text,
      age: int.parse(idadeController.text),
      photo: selectedImage,
      city: selectedCity!,
      neighborhood: selectedNeighborhood!,
      university: selectedUniversity!,
      gender: selectedGender!,
    );

    setState(() => isLoading = false);

    if (token != null) {
      showMsg("Usuário registrado com sucesso!");
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.userSchedule,
        arguments: token,
      );
    } else {
      showMsg("Erro ao registrar usuário");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }


  InputDecoration inputDecor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
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

            // 🆕 Foto
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : null,
                child: selectedImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 35,
                        color: Colors.black54,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            buildInput("Nome", nomeController),
            buildInput("Email", emailController),
            buildInput("Telefone", telefoneController),
            buildInput("Idade", idadeController), // 🆕 Age input
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

  Widget buildInput(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: label == "Idade"
            ? TextInputType.number
            : TextInputType.text,
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
          .map(
            (u) =>
                DropdownMenuItem<int>(value: u["id"], child: Text(u["name"])),
          )
          .toList(),
      onChanged: (v) => setState(() => selectedUniversity = v),
    );
  }

  Widget buildDropdownCities() {
    return DropdownButtonFormField<int>(
      decoration: inputDecor("Cidade"),
      value: selectedCity,
      items: cities
          .map(
            (c) =>
                DropdownMenuItem<int>(value: c["id"], child: Text(c["name"])),
          )
          .toList(),
      onChanged: (v) => setState(() {
        selectedCity = v;
        selectedNeighborhood = null;
      }),
    );
  }

  Widget buildDropdownNeighborhoods() {
    return DropdownButtonFormField<int>(
      decoration: inputDecor("Bairro"),
      value: selectedNeighborhood,
      items: neighborhoods
          .map(
            (b) =>
                DropdownMenuItem<int>(value: b["id"], child: Text(b["name"])),
          )
          .toList(),
      onChanged: (v) => setState(() => selectedNeighborhood = v),
    );
  }
}
