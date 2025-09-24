import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';
import 'package:intl/intl.dart'; // Para formatar a data

class DriverRegisterPage extends StatefulWidget {
  final String token; // JWT do usuário logado
  const DriverRegisterPage({super.key, required this.token});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final TextEditingController cnhController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController corController = TextEditingController();
  final TextEditingController anoController = TextEditingController();

  bool isLoading = false;

  Future<void> submitDriverProfile() async {
    // Validação de campos obrigatórios
    if (cnhController.text.isEmpty ||
        validadeController.text.isEmpty ||
        categoriaController.text.isEmpty ||
        modeloController.text.isEmpty ||
        placaController.text.isEmpty ||
        corController.text.isEmpty ||
        anoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool sucesso = await registerDriverProfile(
      token: widget.token,
      cnh: cnhController.text,
      validadeCnh: validadeController.text,
      categoriaCnh: categoriaController.text,
      modeloCarro: modeloController.text,
      placaCarro: placaController.text,
      corCarro: corController.text,
      anoCarro: int.tryParse(anoController.text) ?? 0,
    );

    setState(() => isLoading = false);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil de motorista registrado!")),
      );
      Navigator.pop(context); // Volta para tela anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao registrar perfil")),
      );
    }
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      validadeController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F1),
          borderRadius: BorderRadius.circular(32),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Registro Motorista',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Quicksand',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(cnhController, 'CNH'),
              _buildDateField(validadeController, 'Validade CNH', context),
              _buildTextField(categoriaController, 'Categoria CNH'),
              _buildTextField(modeloController, 'Modelo do carro'),
              _buildTextField(placaController, 'Placa do carro'),
              _buildTextField(corController, 'Cor do carro'),
              _buildTextField(anoController, 'Ano do carro', isNumber: true),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: isLoading ? null : submitDriverProfile,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF40B59F),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Adicionar perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => pickDate(context),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
