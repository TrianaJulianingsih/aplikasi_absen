import 'package:flutter/material.dart';
import 'package:tugas_13/preference/login.dart';
import 'package:tugas_13/views/login_screen.dart';
import 'package:tugas_13/extension/navigation.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PreferenceHandler.removeLogin();
        context.pushReplacementNamed(Login.id);
      },
      child: Text("Keluar"),
    );
  }
}