import 'package:better_faster_stronger/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:better_faster_stronger/common/user_data.dart';

class UserDataFormView extends StatefulWidget {
  const UserDataFormView({super.key});

  @override
  State<UserDataFormView> createState() => _UserDataFormViewState();
}


class _UserDataFormViewState extends State<UserDataFormView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer
            ]
          )
        ),
        child: SafeArea(
          child: Form(
              child: Column(
                children:[
                  const Spacer(), 
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: genderController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Gender',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Weight',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Height',
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text("Back"),
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.push(context,
                            MaterialPageRoute(builder:
                            (context) => HomeView(
                              userData: UserData(
                                name: nameController.text,
                                gender: genderController.text,
                                age: int.parse(ageController.text),
                                height: int.parse(heightController.text),
                                weight: int.parse(weightController.text),
                                ),
                              ),
                            )
                          )
                        },
                        child: const Text("Enter"),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
            )
          )
        ),
      ),
    );
  }
}
