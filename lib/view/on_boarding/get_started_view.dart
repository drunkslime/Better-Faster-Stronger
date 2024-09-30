import 'package:flutter/material.dart';
import 'login_view.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
        )),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text('Welcome! Let\'s get started!', style: theme.textTheme.titleLarge),
              const Spacer(),
              ElevatedButton.icon(
                  onPressed: () => {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView())
                    )
                  },
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Log in')
                ),
              TextButton(
                onPressed: () => {
                  //------------------
                },
                child: const Text('Sign up', style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ],
          ),
        )
      ),
    );
  }
}
