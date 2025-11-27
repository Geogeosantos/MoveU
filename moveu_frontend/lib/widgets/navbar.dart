import 'package:flutter/material.dart';
import '../features/auth/historic/historic_users.dart';
import '../features/auth/rides/drivers_list_page.dart';
import '../features/auth/rides/rides_request_page.dart';
import '../features/auth/profile/passenger_profile_page.dart';
import '../features/auth/profile/driver_profile_page.dart';

class CustomNavBar extends StatelessWidget {
  final String token;
  final bool isDriver;

  const CustomNavBar({super.key, required this.token, required this.isDriver});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF40B59F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF37A18D), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(
            context: context,
            icon: Icons.home,
            page: isDriver
                ? RideRequestsPage(token: token)
                : DriversListPage(token: token, isDriver: isDriver),
          ),
          _navItem(
            context: context,
            icon: Icons.history,
            page: HistoricoPage(token: token, isDriver: isDriver),
          ),
          _navItem(
            context: context,
            icon: Icons.person,
            page: isDriver
                ? DriverProfilePage(token: token)
                : PassengerProfilePage(token: token),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 45,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }
}
