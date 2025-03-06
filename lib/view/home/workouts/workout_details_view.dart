import 'dart:convert';

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:better_faster_stronger/view/home/exercise/exercise_details.dart';
import 'package:better_faster_stronger/view/home/workouts/add_exercise_page.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

class WorkoutDetailsView extends StatefulWidget {
  final int index;

  const WorkoutDetailsView({super.key, required this.index});

  @override
  State<WorkoutDetailsView> createState() => _WorkoutDetailsViewState();
}

class _WorkoutDetailsViewState extends State<WorkoutDetailsView>
    with SingleTickerProviderStateMixin {
  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
  late TabController _tabController;

  Map<String, dynamic> _userData = {};

  List<dynamic> exercises = [];

  Future<void> _loadUserData() async {
    int? userId =
        await sharedPreferenceService.loadUserId().then((value) => value);
    var httpUrl = Uri.http(databaseService.address,
        '/accessor/accounts/getUserAccount', {'id': userId.toString()});
    await databaseService.getResponse(httpUrl).then((value) {
      if (value.statusCode == 200) {
        while (!mounted) {}
        setState(() {
          _userData = jsonDecode(value.body);
          _userData['workouts'] ??= [];
        });
      } else {
        while (!mounted) {}
        if (mounted) Navigator.pop(context);
      }
    });
  }

  Future<void> _setExercisesList() async {
    var httpUrl =
        Uri.http(databaseService.address, '/accessor/accounts/getWorkout', {
      'id': _userData['workouts'][widget.index]['id'].toString(),
    });
    await databaseService.getResponse(httpUrl).then((workoutValue) async {
      if (workoutValue.statusCode == 200) {
        if (!mounted) return;

        //---------------------------------------------------------------------------------------------
        Logger().i('''Workout Body: ${workoutValue.body}
            \nWorkout Body Runtime type: ${workoutValue.body.runtimeType}
            \nWorkout Decoded Body: ${jsonDecode(workoutValue.body)}
            \nWorkout Decoded Body Runtime type: ${jsonDecode(workoutValue.body).runtimeType}
            \nWorkout Decoded Body[0] Runtime type: ${(jsonDecode(workoutValue.body).length > 0) ? jsonDecode(workoutValue.body)[0]?.runtimeType : null}''');
        //---------------------------------------------------------------------------------------------

        List<dynamic> temp = [];

        for (var i = 0; i < jsonDecode(workoutValue.body).length; i++) {
          var httpUrl = Uri.http(
              databaseService.address,
              '/accessor/exercises/',
              {'id': jsonDecode(workoutValue.body)[i]['id'].toString()});

          await databaseService.getResponse(httpUrl).then((exerciseValue) {
            if (exerciseValue.statusCode == 200) {
              //---------------------------------------------------------------------------------------------
              Logger().i(
                  '''Exercises Decoded Body: ${jsonDecode(exerciseValue.body)}
                    \nExercises Decoded Runtime type: ${jsonDecode(exerciseValue.body).runtimeType}''');
              //---------------------------------------------------------------------------------------------

              temp.add(jsonDecode(exerciseValue.body)[0]);
              temp[i]['Sets'] = jsonDecode(workoutValue.body)[i]['Sets'];
              if (jsonDecode(workoutValue.body)[i].containsKey('Time')) {
                temp[i]['Time'] = jsonDecode(workoutValue.body)[i]['Time'];
              } else {
                temp[i]['Reps'] = jsonDecode(workoutValue.body)[i]['Reps'];
              }
            }
          });
        }

        setState(() {
          exercises = temp;

          //---------------------------------------------------------------------------------------------
          Logger().i('''Exercises List Runtime type: ${exercises.runtimeType}
          \nExercises List Length: ${exercises.length}
          \nExercises List Element Keys: ${(exercises.isNotEmpty) ? exercises[0]?.keys : null}
          \nExercises List Element Runtime type: ${(exercises.isNotEmpty) ? exercises[0].runtimeType : null}''');
          //---------------------------------------------------------------------------------------------
        });
      } else {
        //---------------------------------------------------------------------------------------------
        Logger().e('''Status Code: ${workoutValue.statusCode} 
        \nBody: ${workoutValue.body}''');
        //---------------------------------------------------------------------------------------------

        while (!mounted) {}
        if (mounted) Navigator.pop(context);
      }
    });
  }

  Future<void> _addExercise(Map<String, dynamic>? exercise) async {
    bool isTime = exercise?.keys.contains('Time') ?? false;
    var httpUrl = Uri.http(
        databaseService.address, '/accessor/accounts/addExerciseToWorkout', {
      'workoutId': _userData['workouts'][widget.index]['id'].toString(),
      'exerciseId': exercise?['id'].toString() ?? '',
      'sets': exercise?['Sets'].toString() ?? '',
      (isTime) ? 'time' : 'reps':
          exercise?[(isTime) ? 'Time' : 'Reps'].toString() ?? '',
      'index': exercise?['index'].toString() ?? 'null',
    });

    Logger().i("Url: $httpUrl");

    await databaseService.getResponse(httpUrl).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          _setExercisesList();
        });
      } else {
        Logger().e("Status Code: ${value.statusCode} \nBody: ${value.body}");
      }
    });
  }

  Future<void> _removeExercise(int index) async {
    var httpUrl = Uri.http(databaseService.address,
        '/accessor/accounts/removeExerciseFromWorkout', {
      'workoutId': _userData['workouts'][widget.index]['id'].toString(),
      'index': index.toString(),
    });

    await databaseService.getResponse(httpUrl).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          _setExercisesList();
        });
      } else {
        Logger().e("Status Code: ${value.statusCode} \nBody: ${value.body}");
      }
    });
  }

  void _editExercise(int index, Map<String, dynamic> exercise) async {
    await _removeExercise(index);
    await _addExercise(exercise);
  }

  void _reorderExercise(int oldIndex, int newIndex) async {
    var httpUrl = Uri.http(databaseService.address,
        '/accessor/accounts/reorderExerciseInWorkout', {
      'workoutId': _userData['workouts'][widget.index]['id'].toString(),
      'oldIndex': oldIndex.toString(),
      'newIndex': newIndex.toString(),
    });

    await databaseService.getResponse(httpUrl).then((value) {
      if (value.statusCode == 200) {
        Logger().i("Status Code: ${value.statusCode} \nBody: ${value.body}");
        setState(() {
          _setExercisesList();
        });
      } else {
        Logger().e("Status Code: ${value.statusCode} \nBody: ${value.body}");
      }
    });
  }

  void _setUp() async {
    await _loadUserData();
    _setExercisesList();
  }

  @override
  void initState() {
    super.initState();

    _setUp();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  TextEditingController setsController = TextEditingController();
  String? subSetType;
  TextEditingController subSetsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (_userData.isEmpty || _userData['workouts'] == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var workout = _userData['workouts'][widget.index];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: const Text('Workout Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Plan'),
          ],
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 4.0,
          dividerColor: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsPage(theme, workout),
          _buildPlanPage(theme),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddExercisePage()),
                );
                //-----------------------------------------------------------------------------
                Logger().i(
                    "Result: $result \nResult Runtime Type: ${result.runtimeType}");
                //-----------------------------------------------------------------------------
                if (result?.isNotEmpty ?? false) {
                  _addExercise(result);
                }
              },
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildDetailsPage(ThemeData theme, Map<String, dynamic> workout) {
    return Container(
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Placeholder(
                fallbackHeight: 200, fallbackWidth: double.infinity),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout['name'],
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      workout['description'],
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanPage(ThemeData theme) {
    return Container(
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
      child: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                final item = exercises.removeAt(oldIndex);
                exercises.insert(newIndex, item);

                setState(() {});

                _reorderExercise(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                return Card(
                  key: Key('$index'),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetails(
                            exerciseData: exercises[index],
                          ),
                        ),
                      );
                    },
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Choose Action'),
                                actions: [
                                  TextButton(
                                      child: const Text('Edit'),
                                      onPressed: () async {
                                        var result = await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) {
                                          return AddExercisePage(
                                            exerciseName: exercises[index]
                                                ['name'],
                                          );
                                        }));
                                        if (result?.isNotEmpty ?? false) {
                                          setState(() {
                                            result['index'] = index;
                                            _editExercise(index, result);
                                          });
                                        }
                                      }),
                                  TextButton(
                                    child: const Text('Remove'),
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Remove Exercise'),
                                              content: const Text(
                                                  'Are you sure you want to remove this exercise from your workout?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                TextButton(
                                                  child: const Text('Remove'),
                                                  onPressed: () {
                                                    setState(() {
                                                      _removeExercise(index);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            )),
                                  )
                                ],
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.drag_handle,
                              color: theme.colorScheme.onSurface),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(exercises[index]['name'],
                                style: theme.textTheme.bodyLarge),
                          ),
                          Column(children: [
                            Text(
                              'Sets: ${exercises[index]['Sets'] ?? Null}',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              (exercises[index].containsKey('Time'))
                                  ? 'Time: ${exercises[index]['Time'] ?? Null} min'
                                  : 'Reps: ${exercises[index]['Reps'] ?? Null}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                );
              },
              proxyDecorator: (child, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
