import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'place_details_screen.dart';
import 'saved_trips_page.dart';
import 'package:tripsol_clean/frontend/profile_page.dart';
import 'package:tripsol_clean/frontend/place_card.dart';
import '../frontend/models/place_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Place> _recommendations = [];
  List<Place> _popularPlaces = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final recs = await ApiService.getRecommendations("top");
      final popular = await ApiService.getPopularPlace();
      setState(() {
        _recommendations = recs;
        _popularPlaces = popular;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: \$e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Widget buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError) {
      return const Center(child: Text("Failed to load data. Try again later."));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView(
        children: [
          const Text(
            'Where to next, Hasini?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search destinations...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Recommended Section
          const Text(
            'Recommended for You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _recommendations.isEmpty
              ? const Text('No recommendations available.')
              : SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final place = _recommendations[index];
                      return PlaceCard(
                        title: place.title,
                        description: place.description,
                        imageUrl: place.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlaceDetailsPage(place: place),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

          const SizedBox(height: 28),

          // Popular Section
          const Text(
            'Popular Now',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _popularPlaces.isEmpty
              ? const Text('No popular places found.')
              : SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularPlaces.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final place = _popularPlaces[index];
                      return PlaceCard(
                        title: place.title,
                        description: place.description,
                        imageUrl: place.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlaceDetailsPage(place: place),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomeContent(),
      const SavedTripsPage(),
      const ProfilePage(userEmail: "hasini@gmail.com", savedTripsCount: 2),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("TripSol"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'TripSol Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF8FDFD),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
