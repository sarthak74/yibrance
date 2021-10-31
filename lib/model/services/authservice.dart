import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class AuthService {
  Dio dio = new Dio();
  // String uri = "http://localhost:4000/authenticate";

  String uri = Math().ip() + "/api";
  auth(contact) async {
    try {
      print("auth + $contact");
      Response res = await dio.post(uri + "/auth",
          data: {
            "contact": contact,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      print("auth res+ $res");
      var data = jsonDecode(res.toString());
      print("auth data+ $data");
      // var data = {
      //   "msg": "Otp Sent Succesfully",
      //   "token": "test",
      //   "success": true,
      //   "index": 2
      // };
      print(data);
      Fluttertoast.showToast(
        msg: data["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.grey[500],
        fontSize: 10,
      );
      if (data["success"]) {
        return [true, data["token"]];
      } else {
        return [false];
      }
    } on DioError catch (err) {
      print("error - $err");
      Fluttertoast.showToast(
        msg: "server-side error, Please retry",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 15,
      );
      print("Auth error");
      print(err.response);
    }
  }

  Future<dynamic> verifyotp(otp, token) async {
    try {
      var url = Uri.parse(uri + '/otpverify');
      var tosend = {"otp": otp};
      var res = await http.post(url,
          body: tosend, headers: {HttpHeaders.authorizationHeader: token});

      var data = await jsonDecode(res.body);
      print("Otp response - \ndata -- $data\nUser--${data['contact']}");
      // var data = {
      //   "success": true,
      //   "msg": 'You are authorized',
      //   "isregistered": true,
      //   "contact": "7408159898",
      //   "name": "Shashwat",
      //   "userType": "Reseller"
      // };
      LocalStorage storage = LocalStorage('silkroute');

      String send = "";
      print("print");
      print("print ${data['success']}");
      if (data["success"]) {
        print("suces");
        send += "1";
        Fluttertoast.showToast(
          msg: data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[500],
          fontSize: 10,
        );
        await storage.clear();

        await storage.setItem('contact', data['contact']);
        if (data['registered']) {
          print("red");
          send += "1";
          await storage.setItem('userType', data['userType']);
          await storage.setItem('name', data['name']);
          await storage.setItem('user', data);
          print("Storage User -- ${storage.getItem('user')}");
        } else {
          send += "0";
        }
      } else {
        send += "00";
        Fluttertoast.showToast(
          msg: data['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red,
          fontSize: 10,
        );
      }
      return send;
    } on DioError catch (err) {
      Fluttertoast.showToast(
        msg: err.response.data["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
    }
  }

  getinfo(contact) async {
    try {
      Response res = await dio.post(uri + "/getinfo",
          data: {
            "contact": contact,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      var userData = jsonDecode(res.toString());

      var data = {"success": true, "msg": "Success", "data": userData};

      if (data["success"]) {
        return userData;
      } else {
        Fluttertoast.showToast(
          msg: "Successfully Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[500],
          fontSize: 10,
        );
        return "";
      }
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: err.response.data["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
    }
  }

  register(userData) async {
    try {
      Response res = await dio.post(
        uri + "/register",
        data: {
          "data": userData,
        },
      );
      var data = jsonDecode(res.toString());
      // var data = {
      //   "success": true,
      //   "msg": "Invalid user Data",
      // };

      if (data["success"]) {
        Fluttertoast.showToast(
          msg: "Successfully Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[500],
          fontSize: 10,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red,
          fontSize: 10,
        );
        return false;
      }
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: err.response.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
    }
  }
}
