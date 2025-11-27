import 'package:flutter/material.dart';
import 'passenger_edit_page.dart';
import '../../../data/services/api_service.dart';
import '../../../widgets/navbar.dart'; // import do CustomNavBar

class PassengerProfilePage extends StatefulWidget {
  final String token;

  const PassengerProfilePage({super.key, required this.token});

  @override
  State<PassengerProfilePage> createState() => _PassengerProfilePageState();
}

class _PassengerProfilePageState extends State<PassengerProfilePage> {
  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await getProfile(widget.token);
    setState(() {
      profile = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(token: widget.token, isDriver: false),

      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Perfil do Passageiro",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF40B59F)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _profileHeader(),
                  const SizedBox(height: 20),
                  _sectionTitle("DADOS PESSOAIS"),
                  _infoItem("Nome", profile?["username"] ?? "-"),
                  _infoItem("Idade", profile?["age"]?.toString() ?? "-"),
                  _infoItem("Gênero", _genderToText(profile?["gender"])),
                  const SizedBox(height: 20),

                  _sectionTitle("LOCALIZAÇÃO"),
                  _infoItem(
                    "Universidade",
                    profile?["university"]?["name"] ?? "-",
                  ),
                  _infoItem("Cidade", profile?["city"]?["name"] ?? "-"),
                  _infoItem("Bairro", profile?["neighborhood"]?["name"] ?? "-"),
                  const SizedBox(height: 20),

                  _sectionTitle("DIAS E HORÁRIOS"),
                  _scheduleSection(profile?["schedules"] ?? []),

                  const SizedBox(height: 40),
                  _editButton(context),
                ],
              ),
            ),
    );
  }


  Widget _profileHeader() {
    final photo = profile?["photo"];
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: const Color(0xFF40B59F),
          backgroundImage: photo != null ? NetworkImage(photo) : null,
          child: photo == null
              ? const Icon(Icons.person, color: Colors.white, size: 45)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          profile?["username"] ?? "",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _infoItem(String label, String value) => Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: const Color(0xFFF7F7F7),
      border: Border.all(color: const Color(0xFFEDEDED)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  Widget _scheduleSection(List schedules) {
    if (schedules.isEmpty) {
      return const Text("Nenhum horário cadastrado.");
    }

    return Column(
      children: schedules.map((s) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF0F1F1),
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dayName(s["day"]),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "${s['start_time'].substring(0, 5)} - ${s['end_time'].substring(0, 5)}",
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _editButton(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF40B59F),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassengerEditPage(token: widget.token),
        ),
      );
    },
    child: const Text(
      "Editar Perfil",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    ),
  );

  // Util helpers
  String _genderToText(dynamic g) {
    switch (g) {
      case "M":
        return "Masculino";
      case "F":
        return "Feminino";
      case "O":
        return "Outro";
      default:
        return "-";
    }
  }

  String _dayName(String d) {
    const map = {
      "mon": "Segunda",
      "tue": "Terça",
      "wed": "Quarta",
      "thu": "Quinta",
      "fri": "Sexta",
    };
    return map[d] ?? d;
  }
}
