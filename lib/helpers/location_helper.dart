import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey =
    'pk.eyJ1IjoidmFzdWRldnNvbmkyMDAxIiwiYSI6ImNsMzl6dDh0YTAwOXczYm55bjNnMW9laG0ifQ.TwkiVX6Fi59I2RC1bA-qiw';

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s+e34a4a($longitude,$latitude)/$longitude,$latitude,14,0/300x200?before_layer=admin-0-boundary&access_token=$apiKey';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json?limit=1&types=place%2Cpostcode%2Caddress&access_token=$apiKey');
    final response = await http.get(url);
    return jsonDecode(response.body)['features'][0]['place_name'];
  }
}
