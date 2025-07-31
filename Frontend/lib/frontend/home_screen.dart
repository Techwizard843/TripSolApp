import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'place_details_screen.dart';
import 'saved_trips_page.dart';
import 'package:tripsol_clean/screens/profile_page.dart';
import '../widgets/place_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Place> _recommendations = [];
  bool _isLoading = true;

  final List<Place> _popularPlaces = [
    Place(
      title: 'Manali',
      description: 'Himalayan getaway for snow and mountains',
      imageUrl: 'https://www.india.com/wp-content/uploads/2019/11/Manali.png',
    ),
    Place(
      title: 'Pondicherry',
      description: 'French colonial vibes by the sea',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Pondicherry-Rock_beach_aerial_view.jpg/1200px-Pondicherry-Rock_beach_aerial_view.jpg',
    ),
    Place(
      title: 'Leh-Ladakh',
      description: 'Stunning high-altitude landscapes',
      imageUrl:
          'https://images.unsplash.com/photo-1606857090627-27ca46667290?fm=jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      final recs = await ApiService.getRecommendedPlaces();
      setState(() {
        _recommendations = recs;
        _isLoading = false;
      });
    } catch (e) {
      print('API error: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Where to next, Hasini?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search destinations...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recommended for You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendations.length,
                    itemBuilder: (context, index) {
                      final place = _recommendations[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: PlaceCard(
                          title: place.title,
                          description: place.description,
                          imageUrl: place.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlaceDetailsPage(placeName: place.title),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 20),
          const Text(
            'Popular Now',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _popularPlaces.length,
              itemBuilder: (context, index) {
                final place = _popularPlaces[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: PlaceCard(
                    title: place.title,
                    description: place.description,
                    imageUrl: place.imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaceDetailsPage(placeName: place.title),
                        ),
                      );
                    },
                  ),
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
      const ProfilePage(
        userEmail: "hasini@gmail.com",
        savedTripsCount: 2, // mock value
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("TripSol"),
        backgroundColor: Colors.teal,
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
