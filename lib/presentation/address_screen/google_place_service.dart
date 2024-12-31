import 'package:dio/dio.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class GooglePlacesService {
  final String apiKey;
  final Dio _dio;

  GooglePlacesService(this.apiKey) : _dio = Dio();

  Future<List<PlaceSuggestion>> fetchPlaceSuggestions(
      String input, LatLngBounds? cityBounds) async {
    const baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    try {
      var location = calculateCenterLocation(
        southwestLat: cityBounds?.southwest.latitude ?? 0.0,
        southwestLng: cityBounds?.southwest.longitude ?? 0.0,
        northeastLat: cityBounds?.northeast.latitude ?? 0.0,
        northeastLng: cityBounds?.northeast.longitude ?? 0.0,
      );

      String centerLocation =
          '${location['latitude']},${location['longitude']}';
      const radius = 50000;

      final response = await _dio.get(baseUrl, queryParameters: {
        'query': input,
        'location': centerLocation,
        'radius': radius,
        'key': apiKey
      });

      if (response.statusCode == 200) {
        final List suggestions = response.data['results'];
        var places =
            suggestions.map((json) => PlaceSuggestion.fromJson(json)).toList();

        places.removeWhere(
            (place) => place.address == 'India' || place.address == 'Mumbai');

        return places;
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (e) {
      throw Exception('Error while fetching suggestions: $e');
    }
  }

  Map<String, double> calculateCenterLocation({
    required double southwestLat,
    required double southwestLng,
    required double northeastLat,
    required double northeastLng,
  }) {
    final double centerLat = (southwestLat + northeastLat) / 2;
    final double centerLng = (southwestLng + northeastLng) / 2;

    return {
      'latitude': centerLat,
      'longitude': centerLng,
    };
  }

  Future<PlaceLocationDetails> fetchPlaceDetails(String placeId) async {
    const baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';

    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'place_id': placeId,
        'key': apiKey,
      });

      if (response.statusCode == 200) {
        final result = response.data['result'];
        return PlaceLocationDetails.fromJson(result);
      } else {
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      throw Exception('Error while fetching place details: $e');
    }
  }
}

class PlaceSuggestion {
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String placeId;

  PlaceSuggestion({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.address,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      name: json['name'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      address: json['vicinity'],
      placeId: json['place_id'],
    );
  }
}

class PlaceLocationDetails {
  final double latitude;
  final double longitude;

  PlaceLocationDetails({required this.latitude, required this.longitude});

  factory PlaceLocationDetails.fromJson(Map<String, dynamic> json) {
    return PlaceLocationDetails(
      latitude: json['geometry']['location']['lat'] ?? 0.0,
      longitude: json['geometry']['location']['lng'] ?? 0.0,
    );
  }
}
