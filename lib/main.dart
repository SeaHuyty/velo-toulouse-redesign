import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/app_config.dart';
import 'package:velo_toulouse_redesign/views/screens/map_screen.dart';

Future<void> main() async {
  await dotenv.load();
  final token = AppConfig.mapboxToken;
  if (token.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Velo Toulouse', debugShowCheckedModeBanner: false, home: const MapScreen());
  }
}