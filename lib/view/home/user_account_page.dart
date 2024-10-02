import 'package:flutter/material.dart';
import 'package:better_faster_stronger/common/user_data.dart';

class UserAccountPage extends StatefulWidget {
  final UserData userData;
  const UserAccountPage({super.key, required this.userData});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
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
            Text('Welcome, ${widget.userData.name}!', style: theme.textTheme.titleLarge),
            ElevatedButton.icon(
              onPressed: () => {},
              icon: const Icon(Icons.edit),
              label: const Text("Edit")
            ),
          ],
        )),
      ),
    );
  }
}
