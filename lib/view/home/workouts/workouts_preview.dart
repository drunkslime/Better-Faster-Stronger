import 'dart:convert';

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:better_faster_stronger/view/home/workouts/add_workout_view.dart';
import 'package:better_faster_stronger/view/home/workouts/workout_details_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkoutsPreview extends StatefulWidget {
  const WorkoutsPreview({super.key});

  @override
  State<WorkoutsPreview> createState() => _WorkoutsPreviewState();
}

class _WorkoutsPreviewState extends State<WorkoutsPreview> {
  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  Map<String, dynamic> _userData = {};

  void _loadUserData() async {
    int? userId =
        await sharedPreferenceService.loadUserId().then((value) => value);
    var httpUrl = Uri.http(databaseService.address,
        '/accessor/accounts/getUserAccount', {'id': userId.toString()});
    await databaseService.getResponse(httpUrl).then((value) {
      if (value.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _userData = jsonDecode(value.body);
        });
      } else {
        Navigator.pop(context);
      }
      Logger().i('''User Data: $_userData
        \nWorkouts are null: ${_userData['workouts'] == null}
        \nWorkouts runtimeType: ${_userData['workouts'].runtimeType}
        \nWorkouts are empty (length = 0): ${_userData['workouts'].length == 0}''');
    });
  }

  void _deleteWorkout(int index) async {
    var httpUrl = Uri.http(databaseService.address,
      '/accessor/accounts/deleteWorkout',
      {
        'id': _userData['workouts'][index]['id'].toString(),
        'index': index.toString(),
      }
    );

    await databaseService.getResponse(httpUrl)
      .then((value) {
        if (value.statusCode == 200) {
          setState(() {
            _loadUserData();
          });
        } else {
          Logger().e("Status Code: ${value.statusCode} \nBody: ${value.body}");
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var callback = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddWorkoutView()),
            );
            if (callback == true) {
              _loadUserData();
            }
          },
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: const EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
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
              child: (_userData['workouts'] != null &&
                      _userData['workouts'].isNotEmpty)
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: _userData['workouts'].length ?? 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailsView(
                                    index: index
                                )
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Workout'),
                                content: const Text(
                                  'Are you sure you want to delete this workout? All data inside will be unreturnably lost.'
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () async {
                                      _deleteWorkout(index);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          child: GridTile(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    alignment: Alignment.center,  
                                    color: theme.colorScheme.surface,
                                    child: Column(
                                      children: [
                                        Text(
                                            _userData['workouts'][index]['name'],
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: theme.textTheme.titleLarge),
                                        Text(
                                            "${_userData['workouts'][index]['description']}",
                                            softWrap: true,
                                            maxLines: 5,
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,  
                                            style: theme.textTheme.titleMedium),
                                      ],
                                    ),
                                  ))),
                        );
                      },
                    )
                  : Center(child: Text('Nothing here yet', style: theme.textTheme.displayLarge,)),
            )),
      );
    });
  }
}
