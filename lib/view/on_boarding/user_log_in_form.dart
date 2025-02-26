import 'dart:convert';

import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:better_faster_stronger/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:better_faster_stronger/services/database_service.dart';

class UserLogInForm extends StatefulWidget {
  const UserLogInForm({super.key});

  @override
  State<UserLogInForm> createState() => _UserLogInFormState();
}

class _UserLogInFormState extends State<UserLogInForm> {

  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.all(10),
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
            Text('Logging in', style: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary)),
            const SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Password  ',
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
                  onPressed: () async {
                    try {
                      var httpUrl = Uri.http(databaseService.address,
                        '/accessor/accounts/authUser',
                        {
                          'username': usernameController.text, 'password': passwordController.text
                        }
                      );
                      await databaseService.getResponse(httpUrl)
                                      .then((value) {
                                        if (value.statusCode == 200) { 
                                          sharedPreferenceService.saveUserId(jsonDecode(value.body)['id']);
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return const HomeView();
                                            }));
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${value.statusCode}: ${value.reasonPhrase}')));
                                        }
                                      }
                                    );
                    } catch (e) {
                      Logger().e('e: $e');
                    }
                  },
                  child: const Text("Log In"),
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
