import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';
import '../../../widgets/navbar.dart'; // importe o CustomNavBar

class DriversListPage extends StatefulWidget {
  final String token;
  final bool isDriver;

  const DriversListPage({
    super.key,
    required this.token,
    required this.isDriver,
  });

  @override
  State<DriversListPage> createState() => _DriversListPageState();
}

class _DriversListPageState extends State<DriversListPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> drivers = [];

  @override
  void initState() {
    super.initState();
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    setState(() => isLoading = true);
    drivers = await getAvailableDrivers(widget.token);
    setState(() => isLoading = false);
  }

  Widget buildDriverCard(Map<String, dynamic> driver) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              driver["photo"] ??
                  "https://tse2.mm.bing.net/th/id/OIP.IC51JUj0-SwZuZra-_TYuQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver["username"] ?? "Sem nome",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF352555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  driver["university_name"] ?? "Faculdade não informada",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  driver["neighborhood_name"] ?? "Bairro não informado",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // ação ao clicar
            },
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF40B59F)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Lista de Motoristas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF40B59F)),
            )
          : drivers.isEmpty
          ? const Center(
              child: Text(
                "Nenhum motorista disponível",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadDrivers,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  return buildDriverCard(drivers[index]);
                },
              ),
            ),
      // ✅ Aqui você adiciona a Navbar
      bottomNavigationBar: CustomNavBar(
        token: widget.token,
        isDriver: widget.isDriver,
      ),
    );
  }
}
