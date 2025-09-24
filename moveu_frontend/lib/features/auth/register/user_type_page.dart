import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/api_service.dart'; // importe seu API Service

class UserTypePage extends StatelessWidget {
  final String token;
  const UserTypePage({super.key, required this.token});

  // Função para atualizar tipo de usuário usando API Service
  Future<void> updateUserType(BuildContext context, String tipo) async {
    // Usa o tipo que veio do botão
    bool success = await setUserType(token: token, tipo: tipo);

    if (success) {
      if (tipo == "driver") {
        // Se motorista, vai para registro de motorista
        Navigator.pushNamed(context, AppRoutes.driverRegister, arguments: token);
      } else {
        // Se passageiro, vai para a home/login
        Navigator.pushNamed(context, AppRoutes.login, arguments: token); 
      }
    } else {
      // Mostra erro caso falhe
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar tipo de usuário.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 170),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Eu sou',
              style: TextStyle(
                color: Colors.black,
                fontSize: 47,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 50),

            // Botão Motorista
            ElevatedButton(
              onPressed: () => updateUserType(context, "driver"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40B59F),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Motorista',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botão Passageiro
            ElevatedButton(
              onPressed: () => updateUserType(context, "passenger"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF40B59F), width: 1),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Passageiro',
                style: TextStyle(
                  color: Color(0xFF40B59F),
                  fontSize: 23,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
