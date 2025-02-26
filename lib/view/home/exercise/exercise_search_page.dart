import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/view/home/exercise/exercise_details.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class ExerciseSearchPage extends StatefulWidget {
  const ExerciseSearchPage({super.key});

  @override
  State<ExerciseSearchPage> createState() => _ExerciseSearchPageState();
}

class _ExerciseSearchPageState extends State<ExerciseSearchPage> {
  Logger logger = Logger();

  TextEditingController searchController = TextEditingController();
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
              Text('Find Your Exercise',
                style: TextStyle(
                  fontSize: theme.textTheme.titleLarge?.fontSize,
                  color: theme.colorScheme.onPrimary,
                )),
              SearchBar(
                controller: searchController,
                onSubmitted: (value) async {
                  try {
                    var httpUrl = Uri.http(
                        databaseService.address,
                        '/accessor/exercises/',
                        {'name__startswith': searchController.text});
                    var data = await databaseService.getResponse(httpUrl).then(
                        (value) => ((value.statusCode == 200)
                            ? jsonDecode(value.body)
                            : throw Exception('''
                                            Status code: ${value.statusCode}\n
                                            Body: ${value.body}''')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExerciseDetails(exerciseData: data[0])),
                    );
                  } catch (e) {
                    logger.e('e: $e');
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      var httpUrl = Uri.http(
                          databaseService.address,
                          '/accessor/exercises/',
                          {'name__startswith': searchController.text});
                      var data = await databaseService
                          .getResponse(httpUrl)
                          .then((value) => ((value.statusCode == 200)
                              ? jsonDecode(value.body)
                              : throw Exception('''
                                            Status code: ${value.statusCode}\n
                                            Body: ${value.body}''')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ExerciseDetails(exerciseData: data[0])),
                      );
                    } catch (e) {
                      logger.e('e: $e');
                    }
                  },
                  child: const Text("Search")),
            ],
          ),
        ),
      ),
    );
  }
}
