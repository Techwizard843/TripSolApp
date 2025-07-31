import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultsPage extends StatelessWidget {
  final String placeName;
  final Map<String, dynamic> tripPlan;

  const ResultsPage({
    super.key,
    required this.placeName,
    required this.tripPlan,
  });

  @override
  Widget build(BuildContext context) {
    final planList = tripPlan['plan'] as List<dynamic>? ?? [];
    final totalBudget = tripPlan['total_budget'];
    final travelMode = tripPlan['travel_mode'];
    final startDate = tripPlan['start_date'];
    final endDate = tripPlan['end_date'];

    String formatDate(String iso) {
      final dt = DateTime.tryParse(iso);
      return dt != null ? DateFormat.yMMMd().format(dt) : '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Trip to $placeName'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Custom Trip Plan",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...planList.map((day) {
              return ListTile(
                title: Text("Day ${day['day']}"),
                subtitle: Text((day['activities'] as List).join(", ")),
              );
            }),
            const Divider(height: 30),
            if (totalBudget != null)
              Text(
                "Total Budget: ₹$totalBudget",
                style: const TextStyle(fontSize: 16),
              ),
            if (travelMode != null)
              Text(
                "Travel Mode: $travelMode",
                style: const TextStyle(fontSize: 16),
              ),
            if (startDate != null && endDate != null)
              Text(
                "Dates: ${formatDate(startDate)} → ${formatDate(endDate)}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Call ApiService.saveItinerary(tripPlan)
                Navigator.pop(context); // or show SavedTrips
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Save This Trip"),
            ),
          ],
        ),
      ),
    );
  }
}
