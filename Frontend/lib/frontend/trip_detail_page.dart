import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_services.dart'; // for deleteTrip (optional)

class TripDetailPage extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailPage({super.key, required this.trip});

  String formatDate(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    return dt != null ? DateFormat.yMMMd().format(dt) : '';
  }

  String formatTripForSharing() {
    final buffer = StringBuffer();
    buffer.writeln("Trip to ${trip['place']}");
    buffer.writeln(
      "Dates: ${formatDate(trip['start_date'])} → ${formatDate(trip['end_date'])}",
    );
    buffer.writeln("Budget: ₹${trip['total_budget']}");
    buffer.writeln("Mode: ${trip['travel_mode']}");
    buffer.writeln("\nItinerary:");
    final planList = trip['plan'] as List<dynamic>? ?? [];
    for (var day in planList) {
      buffer.writeln(
        "Day ${day['day']}: ${(day['activities'] as List).join(', ')}",
      );
    }
    return buffer.toString();
  }

  void _shareTrip() {
    final text = formatTripForSharing();
    Share.share(text);
  }

  void _deleteTrip(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Trip"),
        content: const Text("Are you sure you want to delete this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService.deleteTrip(trip['place']); // update email accordingly
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Trip deleted")));
        Navigator.pop(context); // go back to saved trips
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error deleting trip")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final planList = trip['plan'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(trip['place'] ?? 'Trip Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareTrip),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Your Trip to ${trip['place']}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (trip['start_date'] != null && trip['end_date'] != null)
              Text(
                "Dates: ${formatDate(trip['start_date'])} → ${formatDate(trip['end_date'])}",
                style: const TextStyle(fontSize: 16),
              ),
            if (trip['total_budget'] != null)
              Text(
                "Budget: ₹${trip['total_budget']}",
                style: const TextStyle(fontSize: 16),
              ),
            if (trip['travel_mode'] != null)
              Text(
                "Travel Mode: ${trip['travel_mode']}",
                style: const TextStyle(fontSize: 16),
              ),
            const Divider(height: 30),
            Text("Itinerary", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ...planList.map((day) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text("Day ${day['day']}"),
                  subtitle: Text((day['activities'] as List).join(", ")),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteTrip(context),
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Trip"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Future: Navigate to edit screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Edit Trip - Feature coming soon!"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Trip"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
