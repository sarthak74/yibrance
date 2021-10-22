import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  notifyErr(msg) {
    return Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[100],
      textColor: Colors.red,
      fontSize: 12,
    );
  }

  notifySuccess(msg) {
    return Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[100],
      textColor: Colors.green,
      fontSize: 12,
    );
  }

  notifyInfo(msg) {
    return Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[100],
      textColor: Colors.black,
      fontSize: 12,
    );
  }
}
