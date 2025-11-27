import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class PassengerEditPage extends StatefulWidget {
  final String token;

  const PassengerEditPage({super.key, required this.token});

  @override
  State<PassengerEditPage> createState() => _PassengerEditPageState();
}

class _PassengerEditPageState extends State<PassengerEditPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final data = await getProfile(widget.token);

    nomeController.text = data?["username"] ?? "";
    emailController.text = data?["email"] ?? "";
    telefoneController.text = data?["phone_number"] ?? "";

    setState(() => loading = false);
  }

  Future<void> _salvar() async {
    final ok = await updateProfile(
      token: widget.token,
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefoneController.text,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context); // volta para o perfil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil atualizado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar perfil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "EDITAR PERFIL",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: "Quicksand",
            color: Colors.black,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  _title("DADOS PESSOAIS"),
                  const SizedBox(height: 10),

                  _inputField("Nome completo", nomeController),
                  _inputField("Email", emailController),
                  _inputField("Telefone", telefoneController),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40B59F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _salvar,
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF979797),
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w700,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF40B59F), width: 2),
          ),
        ),
      ),
    );
  }
}
