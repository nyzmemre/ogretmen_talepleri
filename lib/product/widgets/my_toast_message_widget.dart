import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/constant/color_constant.dart';

class MyToastMessageWidget{

  Future<bool?> toast({required String msg}){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorConstant.primaryBlue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
