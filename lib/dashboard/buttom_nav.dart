import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/home.dart';
import 'package:tugas_13/views/profile_screen.dart';

class ButtomNav extends StatefulWidget {
  const ButtomNav({super.key});
  static const id = "/buttomNav";

  @override
  State<ButtomNav> createState() => _ButtomNavState();
}

class _ButtomNavState extends State<ButtomNav> {
  // bool appBar = true;
  bool isCheck = false;
  bool isCheckSwitch = false;
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[Home(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Dashbord"), backgroundColor: Colors.blue),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // activeIcon: Icon(Icons.abc_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 12, 92, 65),
        onTap: (value) {
          // print(value);
          // print("Nilai SelecetedIndex Before : $_selectedIndex");

          // print("Nilai BotNav : $value");
          setState(() {
            _selectedIndex = value;
          });
          // print("Nilai SelecetedIndex After: $_selectedIndex");
        },
        // onTap: _onItemTapped,
      ),
    );
  }
}