import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';
import '../../../widgets/navbar.dart';

class DriverProfilePage extends StatefulWidget {
  final String token;

  const DriverProfilePage({super.key, required this.token});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
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
    final driver = profile?["driver"];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(token: widget.token, isDriver: true),

      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Perfil do Motorista",
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
                  _infoItem("Universidade", profile?["university"]?["name"] ?? "-"),
                  _infoItem("Cidade", profile?["city"]?["name"] ?? "-"),
                  _infoItem("Bairro", profile?["neighborhood"]?["name"] ?? "-"),
                  const SizedBox(height: 20),

                  _sectionTitle("DIAS E HORÁRIOS"),
                  _scheduleSection(profile?["schedules"] ?? []),
                  const SizedBox(height: 20),

                  _sectionTitle("DETALHES DO MOTORISTA"),
                  if (driver == null)
                    const Text("Nenhum detalhe registrado.")
                  else ...[
                    _infoItem("Modelo", driver["modelo_carro"] ?? "-"),
                    _infoItem("Placa", driver["placa_carro"] ?? "-"),
                    _infoItem("Cor", driver["cor_carro"] ?? "-"),
                    _infoItem("Ano", driver["ano_carro"]?.toString() ?? "-"),
                    _infoItem("CNH", driver["cnh"] ?? "-"),
                    _infoItem("Categoria CNH", driver["categoria_cnh"] ?? "-"),
                    _infoItem("Validade CNH", _formatDate(driver["validade_cnh"])),
                  ],

                  const SizedBox(height: 40),
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

  String _formatDate(dynamic d) {
    if (d == null) return "-";
    try {
      return d.toString().split("-").reversed.join("/");
    } catch (_) {
      return d.toString();
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
