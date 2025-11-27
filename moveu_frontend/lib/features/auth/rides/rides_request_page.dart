import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';
import 'rides_request_detail_page.dart'; // você vai criar a função para pegar as solicitações
import '../../../widgets/navbar.dart'; // importe o CustomNavBar


class RideRequestsPage extends StatefulWidget {
  final String token;
  const RideRequestsPage({super.key, required this.token});

  @override
  State<RideRequestsPage> createState() => _RideRequestsPageState();
}

class _RideRequestsPageState extends State<RideRequestsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> rideRequests = [];

  @override
  void initState() {
    super.initState();
    loadRideRequests();
  }

  Future<void> loadRideRequests() async {
    setState(() => isLoading = true);
    rideRequests = await getReceivedRideRequests(widget.token); // vamos criar essa função no api_service
    setState(() => isLoading = false);
  }

  Widget buildRideRequestCard(Map<String, dynamic> ride) {
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
              ride["passenger"]["photo"] ??
                  "https://tse2.mm.bing.net/th/id/OIP.IC51JUj0-SwZuZra-_TYuQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride["passenger"]["username"] ?? "Sem nome",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF352555),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideRequestDetailPage(
                    token: widget.token,
                    rideId: ride["id"],
                    passengerData: ride["passenger"], // passa os dados do passageiro
                  ),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_ios),
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
        backgroundColor: const Color(0xFFF0F1F1),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF352555)),
        title: const Text(
          "Solicitações Recebidas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF352555),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF40B59F)),
            )
          : rideRequests.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhuma solicitação recebida",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadRideRequests,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: rideRequests.length,
                    itemBuilder: (context, index) {
                      return buildRideRequestCard(rideRequests[index]);
                    },
                  ),
                ),

      bottomNavigationBar: CustomNavBar(
        token: widget.token,
        isDriver: true, // O perfil aqui SEMPRE é motorista
      ),
    );
  }
}
