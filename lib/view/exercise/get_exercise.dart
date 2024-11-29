import 'dart:math';

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/view/exercise/exercise_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';


class GetExercisePage extends StatefulWidget {
  const GetExercisePage({super.key});

  @override
  State<GetExercisePage> createState() => _GetExercisePageState();
}

class _GetExercisePageState extends State<GetExercisePage> {
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Logger logger = Logger();

    TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Get Exercise', style: theme.textTheme.titleLarge),
              SearchBar( 
                controller: searchController,
                onSubmitted: (value) async {
                    var url = Uri.http('26.136.164.153:8000', '/accessor/exercises/', {'name__startswith': value}); 
                    var response = await http.get(url);
                    if (response.statusCode == 200) {
                      logger.d('response.statusCode: ${response.statusCode} \n value: $value \n response.body: ${response.body}');
                      var data = jsonDecode(response.body);
                      logger.d('jsonDecode data: $data');
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ExerciseDetails(exerciseData: data[0])),
                      );
                    } else {
                      logger.d('response.statusCode: ${response.statusCode} \n value: $value \n response.body: ${response.body}');
                    }
                  },
                ),
              ElevatedButton(
                onPressed: () => {
                  
                },
                child: const Text("Search")
              ),
            ],
          ),
        ),
      ),
    );
  }
}