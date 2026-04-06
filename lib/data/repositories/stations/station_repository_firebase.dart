import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:velo_toulouse_redesign/core/app_config.dart';
import 'package:velo_toulouse_redesign/data/dtos/station_dto.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';

class StationRepositoryFirebase extends StationRepository {
  final String _baseUrl = '${AppConfig.firebaseUrl}/stations';

  @override
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
        .map((e) => StationDto.fromSnapshot(e.key, e.value))
        .toList();
  }
   @override
  Future<StationModel?> getStationById(String stationId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$stationId.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load station $stationId');
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded == null) return null;

    final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);
    return StationDto.fromSnapshot(stationId, data);
  }
}

final stationRepositoryProvider = Provider<StationRepositoryFirebase>((ref) {
  return StationRepositoryFirebase();
});