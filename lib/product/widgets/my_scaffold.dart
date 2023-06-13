import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, this.appBar, this.body});
  final PreferredSizeWidget? appBar;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: ColorConstant.scaffoldBackground,
      appBar: appBar,
      body: body,
    ));
  }
}
