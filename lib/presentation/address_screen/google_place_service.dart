import 'dart:convert';

import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class GooglePlacesService {
  final String apiKey;
  final Dio _dio;

  GooglePlacesService(this.apiKey) : _dio = Dio();

  Future<List<PlaceSuggestion>> fetchPlaceSuggestions(
      String input, LatLngBounds? cityBounds) async {
    const baseUrl = 'https://places.googleapis.com/v1/places:autocomplete';
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

      final response = await _dio.post(baseUrl,
          options: Options(headers: {
            'X-Goog-Api-Key': apiKey,
          }),
          data: {
            "input": input,
            "locationRestriction": {
              "circle": {
                "center": {
                  "latitude": location['latitude'],
                  "longitude": location['longitude']
                },
                "radius": 30000
              }
            }
          });

      if (response.statusCode == 200) {
        final PlaceSuggestionResponds data =
            PlaceSuggestionResponds.fromJson(json.decode(response.toString()));

        if (data.suggestions.isNotEmpty &&
            data.suggestions[0].placePrediction?.text?.text != null) {
          var places = <PlaceSuggestion>[];
          for (var suggestion in data.suggestions) {
            var placeDetails =
                await fetchPlaceDetails(suggestion.placePrediction!.placeId!);

            if (placeDetails.latitude != 0.0 && placeDetails.longitude != 0.0) {
              if (isWithinBounds(
                  LatLng(placeDetails.latitude, placeDetails.longitude),
                  cityBounds!)) {
                places.add(PlaceSuggestion(
                  name: suggestion.placePrediction?.text?.text ?? '',
                  latitude: placeDetails.latitude,
                  longitude: placeDetails.longitude,
                  placeId: suggestion.placePrediction?.placeId ?? '',
                  address: suggestion
                      .placePrediction?.structuredFormat?.mainText?.text,
                ));
              }
            }
          }

          /*  var places = data.suggestions
              .map((suggestion) => PlaceSuggestion(
                    name: suggestion.placePrediction?.text?.text ?? '',
                    latitude: 0.0,
                    longitude: 0.0,
                    placeId: suggestion.placePrediction?.placeId ?? '',
                    address: suggestion
                        .placePrediction?.structuredFormat?.mainText?.text,
                  ))
              .toList();*/

          return places;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  bool isWithinBounds(LatLng location, LatLngBounds bounds) {
    return location.latitude >= bounds.southwest.latitude &&
        location.latitude <= bounds.northeast.latitude &&
        location.longitude >= bounds.southwest.longitude &&
        location.longitude <= bounds.northeast.longitude;
  }

  Map<String, double> calculateCenterLocation({
    required double southwestLat,
    required double southwestLng,
    required double northeastLat,
    required double northeastLng,
  }) {
    final double centerLat = (southwestLat + northeastLat) / 2;
    final double centerLng = (southwestLng + northeastLng) / 2;

    Logger.e('Center location: $centerLat, $centerLng', '#################');
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

class PlaceSuggestionResponds {
  PlaceSuggestionResponds({
    required this.suggestions,
  });

  final List<Suggestion> suggestions;

  factory PlaceSuggestionResponds.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestionResponds(
      suggestions: json["suggestions"] == null
          ? []
          : List<Suggestion>.from(
              json["suggestions"]!.map((x) => Suggestion.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "suggestions": suggestions.map((x) => x.toJson()).toList(),
      };
}

class Suggestion {
  Suggestion({
    required this.placePrediction,
  });

  final PlacePrediction? placePrediction;

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      placePrediction: json["placePrediction"] == null
          ? null
          : PlacePrediction.fromJson(json["placePrediction"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "placePrediction": placePrediction?.toJson(),
      };
}

class PlacePrediction {
  PlacePrediction({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
    required this.types,
  });

  final String? place;
  final String? placeId;
  final TextLocation? text;
  final StructuredFormat? structuredFormat;
  final List<String> types;

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      place: json["place"],
      placeId: json["placeId"],
      text: json["text"] == null ? null : TextLocation.fromJson(json["text"]),
      structuredFormat: json["structuredFormat"] == null
          ? null
          : StructuredFormat.fromJson(json["structuredFormat"]),
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "place": place,
        "placeId": placeId,
        "text": text?.toJson(),
        "structuredFormat": structuredFormat?.toJson(),
        "types": types.map((x) => x).toList(),
      };
}

class StructuredFormat {
  StructuredFormat({
    required this.mainText,
    required this.secondaryText,
  });

  final TextLocation? mainText;
  final SecondaryText? secondaryText;

  factory StructuredFormat.fromJson(Map<String, dynamic> json) {
    return StructuredFormat(
      mainText: json["mainText"] == null
          ? null
          : TextLocation.fromJson(json["mainText"]),
      secondaryText: json["secondaryText"] == null
          ? null
          : SecondaryText.fromJson(json["secondaryText"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "mainText": mainText?.toJson(),
        "secondaryText": secondaryText?.toJson(),
      };
}

class TextLocation {
  TextLocation({
    required this.text,
    required this.matches,
  });

  final String? text;
  final List<Match> matches;

  factory TextLocation.fromJson(Map<String, dynamic> json) {
    return TextLocation(
      text: json["text"],
      matches: json["matches"] == null
          ? []
          : List<Match>.from(json["matches"]!.map((x) => Match.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "matches": matches.map((x) => x?.toJson()).toList(),
      };
}

class Match {
  Match({
    required this.endOffset,
  });

  final int? endOffset;

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      endOffset: json["endOffset"],
    );
  }

  Map<String, dynamic> toJson() => {
        "endOffset": endOffset,
      };
}

class SecondaryText {
  SecondaryText({
    required this.text,
  });

  final String? text;

  factory SecondaryText.fromJson(Map<String, dynamic> json) {
    return SecondaryText(
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
