import 'dart:convert';

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:better_faster_stronger/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String? _dropdownSexValue;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer
            ])),
        child: SafeArea(
            child: Form(
                child: Column(
          children: [
            const Spacer(),
            Text('Registration', style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary)),
            const SizedBox(height: 10.0),
            Row(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text('Username'),
                    hintText: 'Username',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
                const Spacer(),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text('Name'),
                    hintText: 'Name',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                label: Text('Password'),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                  value: _dropdownSexValue,
                  onChanged: (value) {
                    setState(() {
                      _dropdownSexValue = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Sex',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
                const Spacer(),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
                const Spacer(),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Height',
                    constraints: BoxConstraints(maxWidth: 200),
                  ),
                ),
              ],
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
                  onPressed: () async {
                    try {
                      var httpUrl = Uri.http(databaseService.address,
                        '/accessor/accounts/registerUser',
                        {
                          'username': usernameController.text,
                          'password': passwordController.text,
                          'name': nameController.text,
                          'sex': _dropdownSexValue,
                          'age': ageController.text,
                          'height': heightController.text,
                          'weight': weightController.text
                        }
                      );
                      await databaseService
                          .getResponse(httpUrl)
                          .then((value) {
                            if (value.statusCode == 200) {
                              sharedPreferenceService.saveUserId(jsonDecode(value.body)['id']);
                              // ignore: use_build_context_synchronously
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('${value.statusCode}: ${value.reasonPhrase}')
                                    )
                                  );
                                }
                              }
                          );
                    } catch (e) {
                      Logger().e('e: $e');
                    }
                  },
                  child: const Text("Enter"),
                ),
              ],
            ),
            const Spacer(),
          ],
        ))),
      ),
    );
  }
}
