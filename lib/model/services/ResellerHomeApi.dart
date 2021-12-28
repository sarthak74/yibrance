import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class ResellerHomeApi {
  LocalStorage storage = LocalStorage('silkroute');

  Future<List<dynamic>> getCategories() async {
    try {
      print("getcats:");
      var reqBody = {};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getCategories');
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      final res = await http.post(url, body: reqBody, headers: headers);
      List<dynamic> categorylist = jsonDecode(res.body);
      return categorylist;
    } catch (err) {
      print("errorC - $err");
      return err;
    }
  }

  Future<List<dynamic>> getOffers() async {
    // Schema: List<Map<String, String>>
    // [
    //   {
    //     "Title": "",
    //     "Description": "",
    //     "Url": "",
    //     "CouponCode": ""
    //   }, ...
    // ]
    // while applying coupons on crate, check for constraints on backend

    try {
      var reqBody = {};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getOffers');
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      final res = await http.post(url, body: reqBody, headers: headers);
      List<dynamic> offerlist = jsonDecode(res.body);

      return offerlist;
    } catch (err) {
      print("errorO - $err");
      return err;
    }
  }

  Future<List<Map<String, dynamic>>> getTopPicks() async {
    // get product id, main img url & all img url of most viewed
    // Schema: List<Map<String, Dynamic>>
    // [
    //   {
    //     "Id": "",
    //     "MainURL": "",
    //     "AllURLs": [],
    //   }, ...
    // ]

    try {
      var reqBody = {};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getTopPicks');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(url, body: reqBody, headers: headers);
      List<Map<String, dynamic>> toplist = jsonDecode(res.body);

      return toplist;
    } catch (err) {
      print("error - $err");
      return err;
    }
  }
}
