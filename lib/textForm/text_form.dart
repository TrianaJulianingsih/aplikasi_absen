import 'package:flutter/material.dart';

class TextFormConst extends StatelessWidget {
  const TextFormConst({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validator,
  });
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 144, 144, 144),
          ),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(32),
        //   borderSide: BorderSide(
        //     color: const Color.fromARGB(255, 144, 144, 144),
        //     width: 1.0,
        //   ),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(32),
        //   borderSide: BorderSide(
        //     color: const Color.fromARGB(255, 144, 144, 144),
        //     width: 1.0,
        //   ),
        // ),
      ),
    );
  }
}
