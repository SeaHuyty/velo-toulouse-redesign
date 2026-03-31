import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velo_toulouse_redesign/core/map_box_config.dart';
import 'package:velo_toulouse_redesign/views/screens/map_screen.dart';

Future<void> main() async {
  await dotenv.load();
  final token = MapBoxConfig.mapboxToken;
  if (token.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Velo Toulouse', debugShowCheckedModeBanner: false, home: const MapScreen());
  }
}