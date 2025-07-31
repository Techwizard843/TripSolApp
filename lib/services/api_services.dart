import 'dart:async';

class ApiService {
  // ✅ Get Trip Plan – MOCKED (Fast Response)
  static Future<Map<String, dynamic>> getTripPlan(String place) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'plan': [
        {
          'day': 1,
          'activities': ['Assi Ghat', 'Kashi Vishwanath Temple'],
        },
        {
          'day': 2,
          'activities': ['Dashashwamedh Ghat', 'Ganga Aarti'],
        },
        {
          'day': 3,
          'activities': ['Local Food Tour', 'Banarasi Shopping'],
        },
      ],
      'total_budget': 5000,
      'travel_mode': 'Train',
    };
  }

  // ✅ Save Itinerary – MOCKED
  static Future<void> saveItinerary(Map<String, dynamic> itinerary) async {
    await Future.delayed(const Duration(milliseconds: 800));
    print("Trip saved successfully (mock).");
  }

  // ✅ Recommended Places – MOCKED
  static Future<List<Place>> getRecommendedPlaces() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Place(
        title: 'Udaipur',
        description: 'City of Lakes with palaces & boat rides',
        imageUrl:
            'https://www.thepinkcityholidays.com/wp-content/uploads/2023/09/Udaipur-Tour-For-5-Days.jpg',
      ),
      Place(
        title: 'Goa',
        description: 'Beaches, parties, seafood & forts',
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      ),
      Place(
        title: 'Varanasi',
        description: 'Ghats, temples, and spiritual vibes',
        imageUrl: 'https://wallpaperaccess.com/full/4459853.jpg',
      ),
    ];
  }

  // ✅ Customize Trip – MOCKED
  static Future<Map<String, dynamic>> customizeTripPlan(
    Map<String, dynamic> customizationData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      "plan": [
        {
          "day": 1,
          "activities": ["Custom Place 1", "Custom Place 2"],
        },
        {
          "day": 2,
          "activities": ["Custom Place 3", "Custom Place 4"],
        },
      ],
      "total_budget": customizationData['budget'],
      "travel_mode": customizationData['travel_mode'],
      "start_date": customizationData['start_date'],
      "end_date": customizationData['end_date'],
    };
  }

  // ✅ Delete Trip – MOCKED
  static Future<void> deleteTrip(String place, String user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("Deleted trip for $place by $user (mock)");
  }

  // ✅ Get Saved Trips – MOCKED
  static Future<List<Map<String, dynamic>>> getSavedTrips(
    String userEmail,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      {
        "place": "Udaipur",
        "user": userEmail,
        "plan": [
          {
            "day": 1,
            "activities": ["City Palace", "Lake Pichola"],
          },
          {
            "day": 2,
            "activities": ["Fateh Sagar", "Shopping"],
          },
        ],
        "total_budget": 7000,
        "travel_mode": "Train",
        "start_date": "2025-07-10",
        "end_date": "2025-07-12",
      },
      {
        "place": "Goa",
        "user": userEmail,
        "plan": [
          {
            "day": 1,
            "activities": ["Baga Beach", "Anjuna Beach"],
          },
          {
            "day": 2,
            "activities": ["Fort Aguada", "Calangute Market"],
          },
        ],
        "total_budget": 8500,
        "travel_mode": "Flight",
        "start_date": "2025-08-05",
        "end_date": "2025-08-07",
      },
    ];
  }
}

// ✅ Simple Place Model
class Place {
  final String title;
  final String description;
  final String imageUrl;

  Place({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
