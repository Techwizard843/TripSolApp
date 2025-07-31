import 'package:flutter/material.dart';
import 'package:tripsol_clean/screens/trip_detail_page.dart';
import '../services/api_services.dart';

class SavedTripsPage extends StatefulWidget {
  const SavedTripsPage({super.key});

  @override
  State<SavedTripsPage> createState() => _SavedTripsPageState();
}

class _SavedTripsPageState extends State<SavedTripsPage> {
  List<Map<String, dynamic>> _savedTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedTrips();
  }

  Future<void> fetchSavedTrips() async {
    final trips = await ApiService.getSavedTrips("hasini@gmail.com");
    setState(() {
      _savedTrips = trips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Trips"),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedTrips.isEmpty
          ? const Center(child: Text("No saved trips yet."))
          : ListView.builder(
              itemCount: _savedTrips.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final trip = _savedTrips[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripDetailPage(trip: trip),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trip['place'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹${trip['total_budget']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${trip['start_date']} to ${trip['end_date']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Mode: ${trip['travel_mode']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
