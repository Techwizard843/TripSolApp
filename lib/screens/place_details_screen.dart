import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_services.dart';
import 'trip_customization_page.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeName;
  const PlaceDetailsPage({super.key, required this.placeName});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  Map<String, dynamic> tripPlan = {};
  bool isLoading = true;
  bool _isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTripPlan();
  }

  Future<void> fetchTripPlan() async {
    try {
      final plan = await ApiService.getTripPlan(widget.placeName);
      setState(() {
        tripPlan = plan;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch trip plan.';
      });
    }
  }

  void saveItinerary() async {
    setState(() => _isSaving = true);
    final data = {
      'place': widget.placeName,
      'user': 'hasini@gmail.com',
      'plan': tripPlan,
    };

    try {
      await ApiService.saveItinerary(data);
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Success"),
          content: Text("Trip saved successfully!"),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving trip.")));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planList = tripPlan['plan'] as List<dynamic>? ?? [];
    final imageUrl =
        tripPlan['image_url'] ??
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e'; // fallback

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(errorMessage!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchTripPlan,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Trip Plan",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...planList.map((day) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day ${day['day']}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              (day['activities'] as List).join(", "),
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  if (tripPlan.containsKey('total_budget'))
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Budget: ₹${tripPlan['total_budget']}",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (tripPlan.containsKey('travel_mode'))
                    Row(
                      children: [
                        const Icon(Icons.directions_bus, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "Travel Mode: ${tripPlan['travel_mode']}",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : saveItinerary,
                          icon: _isSaving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            _isSaving ? "Saving..." : "Trip Details",
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripCustomizationPage(
                                  placeName: widget.placeName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.tune),
                          label: const Text("Customize Trip"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[300],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
