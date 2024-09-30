import 'package:flutter/material.dart';
import 'package:better_faster_stronger/view/home/user_account_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ElevatedButton(
            onPressed: () => {
              Navigator.pop(context)
            },
            child: const Text("Back"),
            ),
            ElevatedButton(
            onPressed: () => {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserAccountView())
              )
            },
            child: const Text("Enter"),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
