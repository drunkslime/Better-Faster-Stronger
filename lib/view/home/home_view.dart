import 'package:better_faster_stronger/view/home/exercise/exercise_search_page.dart';
import 'package:better_faster_stronger/view/home/user_account_page.dart';
import 'package:better_faster_stronger/view/home/workouts/workouts_preview.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const WorkoutsPreview();
        break;
      case 1:
        page = const ExerciseSearchPage();
        break;
      case 2:
        page = const UserAccountPage();
        break;
      default:
        page = const Placeholder();
        break;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: page,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined),
                label: "Workouts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: "Account",
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: theme.colorScheme.surfaceContainer,
            unselectedItemColor: theme.colorScheme.onSurface,
            selectedItemColor: theme.colorScheme.primary,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
