import 'package:flutter/material.dart';
import '../../core/constant/text_constant.dart';
import '../../product/widgets/my_scaffold.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      body: Column(
        children: [
          Text(TextConstant.salam),
        ],
      ),
    );
  }
}
