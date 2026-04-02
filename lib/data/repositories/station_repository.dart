import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final dynamic decoded = jsonDecode(response.body);

    if (decoded == null) {
      return <StationModel>[];
    }

    final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);

    return data.entries
        .map((e) => StationModel.fromSnapshot(e.key, e.value))
        .toList();
  }
}

final stationRepositoryProvider = Provider<StationRepository>((ref) {
  return StationRepository();
});