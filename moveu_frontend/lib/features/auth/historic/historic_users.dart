import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class HistoricoPage extends StatefulWidget {
  final String token; // token do usuário logado

  const HistoricoPage({super.key, required this.token});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  late Future<List<Map<String, dynamic>>> futureHistorico;

  @override
  void initState() {
    super.initState();
    futureHistorico = getRideHistory(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Histórico de Corridas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureHistorico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar histórico."));
          }

          final rides = snapshot.data ?? [];

          if (rides.isEmpty) {
            return const Center(child: Text("Nenhuma corrida encontrada."));
          }

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];

              // Dependendo de como o JSON da API vier, ajuste os campos
              final passengerName =
                  ride['passenger']?['username'] ?? 'Passageiro';
              final driverName = ride['driver']?['username'] ?? 'Motorista';
              final origem =
                  ride['neighborhood_name'] ??
                  ride['university_name'] ??
                  'Origem';
              final data = ride['created_at']?.substring(0, 10) ?? '';
              final hora = ride['start_time'] ?? '';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Color(0x11000000), blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passageiro: $passengerName",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Motorista: $driverName",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Origem: $origem",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hora,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
