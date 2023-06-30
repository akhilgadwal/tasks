import 'package:flutter/material.dart';

import '../../main.dart';

class MyButton extends StatelessWidget {
  MyButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColorprimary,
        shape: const StadiumBorder(),
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: bgColorSecondary),
      ),
    );
  }
}
