import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/buttom_nav.dart';
import 'package:tugas_13/views/list_kehadiran.dart';
import 'package:tugas_13/views/laporan_screen.dart';
import 'package:tugas_13/views/login_screen.dart';
import 'package:tugas_13/extension/navigation.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  int _selectedIndexDrawer = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   SizedBox(),
  //   CheckBoxPage(),
  //   SwitchPage(),
  //   DropdownPage(),
  //   DatepickerPage(),
  //   TimepickerPage(),
  //   ListVoucher(),
  // ];
  void onItemTap(int index) {
    setState(() {
      _selectedIndexDrawer = index;
    });
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/peta.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              'Travel',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 6, 6, 6),
                fontSize: 30,
                fontFamily: "Lobster",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              context.push(ButtomNav());
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Kehadiran"),
            onTap: () {
              context.push(ListKehadiran());
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text("Laporan"),
            onTap: () {
              context.push(LaporanScreen());
            },
          ),
        ],
      ),
    );
  }
}