import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_toulouse_redesign/core/app_config.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';

class StationRepository {
  final String _baseUrl = '${AppConfig.firebaseUrl}/stations';

  Future<List<StationModel>> getStations() async {
    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load stations');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return data.entries
        .map((e) => StationModel.fromSnapshot(e.key, e.value))
        .toList();
  }
}
