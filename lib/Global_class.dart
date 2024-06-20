import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


class Global_method {

  static show_toast({required String msg, required BuildContext context}) {
    showToast('${msg}',
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: Color(0xFF002147),
      reverseCurve: Curves.linear,
    );
  }
}