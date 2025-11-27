import 'package:flutter/material.dart';

class PassengerEditPage extends StatefulWidget {
  const PassengerEditPage({super.key});

  @override
  State<PassengerEditPage> createState() => _PassengerEditPageState();
}

class _PassengerEditPageState extends State<PassengerEditPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController faculdadeController = TextEditingController();
  final TextEditingController diasController = TextEditingController();
  final TextEditingController horariosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [

            const SizedBox(height: 10),
            _title("DADOS PESSOAIS"),
            const SizedBox(height: 10),

            _inputField("Nome completo", nomeController),
            _inputField("Idade", idadeController),
            _inputField("Faculdade", faculdadeController),

            const SizedBox(height: 25),
            _title("DIAS E HORÁRIOS"),
            const SizedBox(height: 10),

            _inputField("Dias disponíveis", diasController),
            _inputField("Horários", horariosController),

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

  void _salvar() {
    // Aqui você faz o PUT/POST no backend Django
    print("Salvando perfil do passageiro...");
    print("Nome: ${nomeController.text}");
    print("Idade: ${idadeController.text}");
    print("Faculdade: ${faculdadeController.text}");
    print("Dias: ${diasController.text}");
    print("Horários: ${horariosController.text}");

  
  }
}
