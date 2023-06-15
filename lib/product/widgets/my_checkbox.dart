import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:kartal/kartal.dart';

class MyCheckbox extends StatelessWidget {
  const MyCheckbox({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundCheckBox(
          onTap: (selected) {},),
        context.emptySizedWidthBoxLow,
        Expanded(child: Text(' $text')),
      ],
    );
  }
}
