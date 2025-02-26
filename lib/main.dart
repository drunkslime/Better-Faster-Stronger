// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:better_faster_stronger/view/on_boarding/get_started_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
    Logger().i(
      '@Main: User ID: ${sharedPreferenceService.loadUserId()}'
      + '\n@Main: User ID Runtime Type: ${sharedPreferenceService.loadUserId().runtimeType}',
    );
    return MaterialApp(
      title: 'Better,Faster,Stronger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const GetStartedView(),

    );
  }
}
