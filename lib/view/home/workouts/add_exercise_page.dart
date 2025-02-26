// ignore_for_file: use_build_context_synchronously, prefer_adjacent_string_concatenation

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class AddExercisePage extends StatefulWidget {
  String? exerciseName;
  AddExercisePage({super.key, this.exerciseName});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  Logger logger = Logger();

  TextEditingController searchController = TextEditingController();
  DatabaseService databaseService = DatabaseService();

  TextEditingController setsController = TextEditingController();
  TextEditingController subSetsController = TextEditingController();
  String subSetsType = 'Reps';

  Map<String, dynamic> chosenExercise = {};

  void _searchExercise() async {
    try {
      var httpUrl = Uri.http(databaseService.address, '/accessor/exercises/',
          {'name__startswith': searchController.text});

      await databaseService.getResponse(httpUrl).then((value) =>
          ((value.statusCode == 200)
              ? chosenExercise = jsonDecode(value.body)[0]
              : ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Not Found')))));
      setState(() {});
    } catch (e) {
      logger.e('e: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    searchController.text = widget.exerciseName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Exercise',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Choose Exercise',
                        style: TextStyle(
                          fontSize: theme.textTheme.titleLarge?.fontSize,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      SearchBar(
                          controller: searchController,
                          onSubmitted: (value) async {
                            _searchExercise();
                          },
                          leading: IconButton(
                            onPressed: () async {
                              _searchExercise();
                            },
                            icon: const Icon(Icons.search),
                          ),
                          trailing: <Widget>[
                            IconButton(
                              onPressed: () => {
                                setState(() {
                                  searchController.clear();
                                })
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ]),
                      Card(
                        elevation: 2,
                        color: theme.colorScheme.surfaceDim,
                        surfaceTintColor: theme.colorScheme.surfaceTint,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: theme.colorScheme.primary,
                                    ),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            '${chosenExercise['image'] ?? 'assets/img/bfs_icon.png'}')),
                                  ),
                                  SizedBox(
                                    width: 175,
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      '${chosenExercise['name'] ?? 'Exercise not chosen, yet'}',
                                      style: TextStyle(
                                          fontSize: theme
                                              .textTheme.titleLarge?.fontSize,
                                          color: theme.colorScheme.onSurface),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${chosenExercise['type'] ?? ''}',
                                  ),
                                  Text(
                                    '${chosenExercise['group'] ?? ''}',
                                  ),
                                  Text(
                                    '${chosenExercise['mechanics'] ?? ''}',
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sets', style: TextStyle(fontSize: 20, color: theme.colorScheme.onPrimary),),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: setsController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Sets',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: DropdownButtonFormField(
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Reps',
                                      child: Text('Reps'),
                                    ),
                                    DropdownMenuItem(
                                        value: 'Time', child: Text('Time'))
                                  ],
                                  value: subSetsType,
                                  onChanged: (value) {
                                    setState(() {
                                      subSetsType = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Subsets',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: subSetsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: const OutlineInputBorder(),
                                    labelText: subSetsType,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            {
                              "id": chosenExercise['id'] ?? '',
                              "Sets": setsController.text,
                              subSetsType: subSetsController.text
                            }
                          );
                        },
                        child: const Text('Submit')
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
