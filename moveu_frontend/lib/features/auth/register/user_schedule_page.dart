import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/api_service.dart'; // função setUserSchedule

class UserSchedulePage extends StatefulWidget {
  final String token;
  const UserSchedulePage({super.key, required this.token});

  @override
  State<UserSchedulePage> createState() => _UserSchedulePageState();
}

class _UserSchedulePageState extends State<UserSchedulePage> {
  final Map<String, TimeOfDay?> startTimes = {};
  final Map<String, TimeOfDay?> endTimes = {};

  // Dias visíveis na UI
  final List<String> daysOfWeek = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  // Mapeamento para enviar ao backend
  final Map<String, String> dayMap = {
    'Segunda': 'mon',
    'Terça': 'tue',
    'Quarta': 'wed',
    'Quinta': 'thu',
    'Sexta': 'fri',
  };

  String timeOfDayToString(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return "$hours:$minutes:00"; // adiciona segundos
}


  bool isLoading = false;

  Future<void> pickTime(BuildContext context, String day, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTimes[day] = picked;
        } else {
          endTimes[day] = picked;
        }
      });
    }
  }

  Future<void> submitSchedule() async {
    setState(() => isLoading = true);

    bool allSuccess = true;

    for (var day in daysOfWeek) {
      final start = startTimes[day];
      final end = endTimes[day];

      if (start != null && end != null) {
        bool success = await setUserSchedule(
          token: widget.token,
          day: dayMap[day]!,
          startTime: timeOfDayToString(start),
          endTime: timeOfDayToString(end),
        );
        if (!success) allSuccess = false;
      }
    }

    setState(() => isLoading = false);

    if (allSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Horários salvos com sucesso!")),
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.userType,
        arguments: widget.token,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao salvar horários.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F1),
      appBar: AppBar(
        title: const Text(
          "Cadastro de Horários",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF352555),
          ),
        ),
        backgroundColor: const Color(0xFFF0F1F1),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF352555)),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF40B59F)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 90,
              ), // aumentei de 30 para 60
              child: Column(
                children: [
                  ...daysOfWeek.map(
                    (day) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              day,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF352555),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => pickTime(context, day, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF40B59F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              startTimes[day]?.format(context) ?? "Início",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => pickTime(context, day, false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF40B59F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              endTimes[day]?.format(context) ?? "Fim",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: submitSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40B59F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Salvar Horários',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
