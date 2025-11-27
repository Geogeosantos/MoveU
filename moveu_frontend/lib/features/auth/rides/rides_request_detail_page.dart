import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class RideRequestDetailPage extends StatefulWidget {
  final String token;
  final int rideId;
  final Map<String, dynamic> passengerData;

  const RideRequestDetailPage({
    super.key,
    required this.token,
    required this.rideId,
    required this.passengerData,
  });

  @override
  State<RideRequestDetailPage> createState() => _RideRequestDetailPageState();
}

class _RideRequestDetailPageState extends State<RideRequestDetailPage> {
  bool isProcessing = false;

  Future<void> updateRideStatus(String status) async {
    setState(() => isProcessing = true);

    final success = await postRideStatus(
      token: widget.token,
      rideId: widget.rideId,
      status: status,
    );

    setState(() => isProcessing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Solicitação $status com sucesso!")),
      );
      Navigator.pop(context, status);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar status da solicitação.")),
      );
    }
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildScheduleRow(String day, String startTime, String endTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("$startTime - $endTime"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passenger = widget.passengerData;

    // função auxiliar para converter gênero
    String formatGender(String? gender) {
      if (gender == "M") return "Masculino";
      if (gender == "F") return "Feminino";
      return "-";
    }

    final schedules = passenger["schedules"] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil Passageiro"),
        backgroundColor: const Color(0xFFF0F1F1),
        iconTheme: const IconThemeData(color: Color(0xFF352555)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  passenger["photo"] ??
                      "https://tse2.mm.bing.net/th/id/OIP.IC51JUj0-SwZuZra-_TYuQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
                ),
              ),
              const SizedBox(height: 20),
              Text(passenger["username"] ?? "Sem nome",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF352555))),
              const SizedBox(height: 10),

              // Informações gerais
              buildInfoRow("Faculdade", passenger["university_name"] ?? "-"),
              buildInfoRow("Bairro", passenger["neighborhood_name"] ?? "-"),
              buildInfoRow("Email", passenger["email"] ?? "-"),
              buildInfoRow("Telefone", passenger["phone_number"] ?? "-"),
              buildInfoRow("Gênero", formatGender(passenger["gender"])),

              const Divider(height: 30, thickness: 1),

              // Horários
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Horários",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              const SizedBox(height: 10),

              if (schedules.isEmpty)
                const Text("Sem horários cadastrados")
              else
                ...schedules.map((s) => buildScheduleRow(
                      s["day"] ?? "-",
                      s["start_time"] ?? "-",
                      s["end_time"] ?? "-",
                    )),
              const SizedBox(height: 30),

              // Botões
              isProcessing
                  ? const CircularProgressIndicator(color: Color(0xFF40B59F))
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => updateRideStatus("accepted"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40B59F),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text(
                            "Aceitar",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => updateRideStatus("rejected"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text(
                            "Recusar",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}