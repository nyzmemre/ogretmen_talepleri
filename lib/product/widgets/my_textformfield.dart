import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../core/constant/text_constant.dart';


class MyTextFormField extends StatelessWidget {
  const MyTextFormField({Key? key, required this.controller, required this.hintText, this.maxLines}) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;


  @override
  Widget build(BuildContext context) {
    double pageWidth= (context.width>450) ? .6 : .8;
    print(pageWidth);
    return SizedBox(
      width: context.width*pageWidth,
      child: TextFormField(
        validator: (val){
          if(hintText!=TextConstant.formName) {
            if(val==null || val=='') {
              return 'Bu alan boş kalamaz';
            }
          }

        },
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          )),
    );;
  }
}
