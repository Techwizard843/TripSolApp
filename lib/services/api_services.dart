import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import '../models/flight_model.dart';
import '../models/train_model.dart';
import '../models/hotel_model.dart';
import '../models/food_model.dart';
import '../models/weather_model.dart';
import '../models/ml_model.dart';
import '../models/trip_model.dart';

const String baseUrl = 'https://tripsolapp.onrender.com';

class ApiService {
  //Trip APIs

  static Future<Trip> createTrip({
    required String userId,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('$baseUrl/api/trips');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "destination": destination,
        "startDate": startDate,
        "endDate": endDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Trip.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create trip");
    }
  }

  //Flight API

  static Future<List<Flight>> getFlights({
    required String from,
    required String to,
    required String date,
  }) async {
    final url = Uri.parse('$baseUrl/api/flights?from=$from&to=$to&date=$date');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Flight.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch flights");
    }
  }

  // Train API

  static Future<List<Train>> getTrains({
    required String from,
    required String to,
    required String date,
  }) async {
    final url = Uri.parse('$baseUrl/api/trains?from=$from&to=$to&date=$date');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Train.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch trains");
    }
  }

  //Hotel API

  static Future<List<Hotel>> getHotels(String city) async {
    final url = Uri.parse('$baseUrl/hotels?city=$city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Hotel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch hotels");
    }
  }

  //Food API

  static Future<List<FoodPlace>> getFoodSuggestions(String city) async {
    final url = Uri.parse('$baseUrl/api/food?city=$city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => FoodPlace.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch food suggestions");
    }
  }

  //  Weather API

  static Future<WeatherInfo> getWeather(String city) async {
    final url = Uri.parse('$baseUrl/api/weather?city=$city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch weather info");
    }
  }

  //ML Recommendations

  /* static Future<List<MLRecommendation>> getMLRecommendations(
    String tripId,
  ) async {
    final url = Uri.parse('$baseUrl/api/ml?tripId=$tripId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => MLRecommendation.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch ML recommendations");
    }
  }*/

  // Existing (Popular & Custom Recommendations)

  static Future<List<Place>> getRecommendations(String userId) async {
    final url = Uri.parse('$baseUrl/recommendations?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((placeJson) => Place.fromJson(placeJson)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  /*static Future<List<Place>> getPopularPlaces() async {
    final url = Uri.parse('$baseUrl/api/popular');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((placeJson) => Place.fromJson(placeJson)).toList();
    } else {
      throw Exception('Failed to load popular places');
    }
  }*/

  // Get Trip Plan
  static Future<Map<String, dynamic>> getTripPlan(String destination) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tripdetails'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"destination": destination}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load trip details');
    }
  }

  // Google OAuth Login
  static Future<void> loginWithOAuth(
    String email,
    String name,
    String idToken,
  ) async {
    final url = Uri.parse('$baseUrl/auth/google');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'name': name, 'token': idToken}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log in via OAuth');
    }

    print("OAuth Login Success: ${response.body}");
  }

  // Save Itinerary
  static Future<void> saveItinerary(Map<String, dynamic> itinerary) async {
    final url = Uri.parse('$baseUrl/save-trip');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "UID": itinerary['UID'],
        "tripName": itinerary['tripName'],
        "startDate": itinerary['startDate'],
        "endDate": itinerary['endDate'],
        "preferences": itinerary['preferences'] ?? {},
      }),
    );

    if (response.statusCode == 201) {
      print("Trip saved successfully!");
    } else {
      print("Failed to save trip: ${response.body}");
    }
  }

  // Recommended Places
  static Future<List<Place>> getRecommendation(String input) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recommendation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userinput": input}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception("Failed to get recommendations");
    }
  }

  // Popular Places
  static Future<List<Place>> getPopularPlace() async {
    final url = Uri.parse('$baseUrl/api/popular');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular places');
    }
  }

  // Customize Trip
  static Future<Map<String, dynamic>> customizeTripPlan(
    String tripId,
    Map<String, dynamic> customizationData,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/customize-trip/$tripId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customizationData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to customize trip');
    }
  }

  // Delete Trip
  static Future<void> deleteTrip(String tripId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-trip/$tripId'),
    );

    if (response.statusCode == 200) {
      print("Trip deleted successfully");
    } else {
      throw Exception("Failed to delete trip");
    }
  }

  // Get Saved Trips
  static Future<List<Map<String, dynamic>>> getSavedTrips(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/get-trips/$uid'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['trips']);
    } else {
      throw Exception('Failed to load saved trips');
    }
  }

  //Get Trip by ID
  static Future<Map<String, dynamic>?> getTripById(String tripId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-trip/$tripId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['trip']; // Trip data is inside the 'trip' key
      } else {
        print('Failed to get trip. Status code: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error while fetching trip: $e');
      return null;
    }
  }
}
