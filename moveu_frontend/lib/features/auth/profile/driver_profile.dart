import 'package:flutter/material.dart';

class DriverEditPage extends StatefulWidget {
  const DriverEditPage({super.key});

  @override
  State<DriverEditPage> createState() => _DriverEditPageState();
}

class _DriverEditPageState extends State<DriverEditPage> {
  // Controllers dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController faculdadeController = TextEditingController();
  final TextEditingController carroController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController corController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController cnhController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();

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
            fontWeight: FontWeight.bold,
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

            const SizedBox(height: 20),
            _title("MEU VEÍCULO"),
            const SizedBox(height: 10),

            _inputField("Carro", carroController),
            _inputField("Ano", anoController),
            _inputField("Cor", corController),
            _inputField("Placa", placaController),

            const SizedBox(height: 20),
            _title("DOCUMENTO"),
            const SizedBox(height: 10),

            _inputField("Número CNH", cnhController),
            _inputField("Validade CNH", validadeController),

            const SizedBox(height: 20),
            _title("DIAS E HORÁRIOS"),
            const SizedBox(height: 10),

            _inputField("Dias disponíveis", TextEditingController()),
            _inputField("Horários", TextEditingController()),

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
              onPressed: () {
                _salvar();
              },
              child: const Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
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
        fontWeight: FontWeight.bold,
        color: Colors.black,
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
            borderSide: const BorderSide(
              color: Color(0xFFEEEEEE),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF40B59F),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  void _salvar() {
    // Aqui você envia os dados para o backend Django
    print("Salvando alterações...");

    print("Nome: ${nomeController.text}");
    print("Idade: ${idadeController.text}");
    print("Faculdade: ${faculdadeController.text}");
    print("Carro: ${carroController.text}");
    print("Ano: ${anoController.text}");
    print("Cor: ${corController.text}");
    print("Placa: ${placaController.text}");
    print("CNH: ${cnhController.text}");
    print("Validade: ${validadeController.text}");
  }
}
