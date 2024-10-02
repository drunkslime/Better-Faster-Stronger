import 'package:flutter/material.dart';
import 'package:better_faster_stronger/view/home/user_account_page.dart';
import 'package:better_faster_stronger/view/home/search_page.dart';
import 'package:better_faster_stronger/common/user_data.dart';

class HomeView extends StatefulWidget {
  final UserData userData;
  const HomeView({super.key, required this.userData});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _selectedIndex = 0;

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
        page = const Placeholder(); // TODO - SETTINGS
        break;
      case 1:
        page = const Placeholder(); // TODO - CALENDAR
        break;
      case 2:
        page = const SearchPage();
        break;
      case 3:
        page = const Placeholder(); // TODO - TRAININGS
        break;
      case 4:
        page = UserAccountPage(userData: widget.userData);
        break;
      default:
        page = UserAccountPage(userData: widget.userData,);
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
                icon: Icon(Icons.settings_outlined),
                label: "Settings"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: "Calendar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined),
                label: "Workouts",
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
