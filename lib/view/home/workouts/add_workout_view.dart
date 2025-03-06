import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';


class AddWorkoutView extends StatefulWidget {
  const AddWorkoutView({super.key});

  @override
  State<AddWorkoutView> createState() => _AddWorkoutViewState();
}

class _AddWorkoutViewState extends State<AddWorkoutView> {

  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int? userId;

  void getUserId() async {
    userId = await sharedPreferenceService.loadUserId().then((value) => value);
  }

  void _saveWorkout(String name, String description) async {
    var httpUrl = Uri.http(databaseService.address,
      '/accessor/accounts/addWorkout',
      {
        'id': userId.toString(),
        'name': name,
        'description': description
      }
    );
    await databaseService.getResponse(httpUrl)
      .then((value) {
        if (value.statusCode == 200) {
          while(!mounted) {}
          if(mounted) Navigator.pop(context, true);
        }
        else {
          Logger().i(value.body);
          while(!mounted){}
          if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.statusCode.toString())));
        }
      });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return Scaffold(
                body: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
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
                    child: SafeArea(
                      child: Form(
                        child: Column(
                          children: [
                            const Spacer(),
                            Text('Add Workout', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Workout Name',
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Description',
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              child: const Text('Save'),
                              onPressed: () => {
                                _saveWorkout(nameController.text, descriptionController.text)
                              }
                            ),
                            const Spacer(),
                          ],
                        ) 
                      ),
                    ),
                  )
                ),
              );
            }
        );
    }
}