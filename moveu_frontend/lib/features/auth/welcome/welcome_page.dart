import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F1), // cor principal do app
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Column(
                children: [
                  Image.asset(
                    'lib/data/assets/images/logo.jpg', // coloque sua logo aqui
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Seja bem-vindo(a) ao MoveU',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF40B59F),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ],
              ),

              // Texto descritivo
              const Text(
                'Seu mais novo app de carona universitária',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF40B59F),
                  fontSize: 30,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Botão
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40B59F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  'Vamos começar!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
