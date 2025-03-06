import 'dart:convert';

import 'package:better_faster_stronger/services/database_service.dart';
import 'package:better_faster_stronger/services/shared_preference_service.dart';
import 'package:flutter/material.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {

  DatabaseService databaseService = DatabaseService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  
  Map<String, dynamic> _userData = {};

  void _loadUserData() async {
    int? userId = await sharedPreferenceService.loadUserId().then((value) => value);
    var httpUrl = Uri.http(databaseService.address,
      '/accessor/accounts/getUserAccount',
      {
        'id': userId.toString()
      }
    );
    await databaseService.getResponse(httpUrl)
      .then((value) {
        if (value.statusCode == 200) {
          setState(() {
            _userData = jsonDecode(value.body);
          });
        } else {
          while(!mounted) {}
          if (mounted) Navigator.pop(context);
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
            ],
          ),
        ),
        child: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${_userData['name']}', style: theme.textTheme.titleLarge),
          ],
        )),
      ),
    );
  }
}
