import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

// IMPORTANTE: importar o arquivo onde está seu navbar + IndexedStack
import 'widgets/navbar.dart';
import 'features/auth/welcome/welcome_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/auth/register/user_type_page.dart';
import 'features/auth/register/user_schedule_page.dart';
import 'features/auth/register/driver_register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: (settings) {
        switch (settings.name) {

          case AppRoutes.welcome:
            return MaterialPageRoute(builder: (_) => const WelcomePage());

          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginPage());

          case AppRoutes.register:
            return MaterialPageRoute(builder: (_) => const RegisterPage());

          case AppRoutes.userSchedule:
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => UserSchedulePage(token: token),
            );

          case AppRoutes.userType:
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => UserTypePage(token: token),
            );

          case AppRoutes.driverRegister:
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => DriverRegisterPage(token: token),
            );

          // ⭐ NOVA ROTA PRINCIPAL COM NAVBAR
          case AppRoutes.homeNavigation:
            return MaterialPageRoute(
              builder: (_) => const CustomNavBar(),
            );

          default:
            return null;
        }
      },
    );
  }
}
