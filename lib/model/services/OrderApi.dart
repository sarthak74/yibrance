import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/OrderListItem.dart';

class OrderApi {
  LocalStorage storage = LocalStorage('silkroute');

  Future<List<OrderListItem>> getOrders() async {
    try {
      var contact = await storage.getItem('contact');
      var userType = await storage.getItem('userType');
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var apiRoute =
          (userType == "Reseller") ? "resellerApi" : "manufacturerApi";
      var reqBody = {"contact": contact};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/' + apiRoute + '/getOrders');
      final res = await http.post(url, body: reqBody, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      List<OrderListItem> resp = [];
      print("decodedRes2 $decodedRes2");
      for (var i in decodedRes2) {
        // print("items: ${i['items']}");
        OrderListItem r = OrderListItem.fromMap(i);
        resp.add(r);
      }
      return resp;
    } catch (e) {
      print("Get Order error - $e");
      return e;
    }
  }

  Future<dynamic> setOrder(order) async {
    try {
      var data = order;
      print("Set order data -  $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/setOrder');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      print("Set order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);

      print("Set order res -  ${decodedRes2['success']}");
      return decodedRes2;
    } catch (e) {
      print("Set Order error - $e");
      return {"success": false};
    }
  }

  Future<dynamic> updateOrder(id, body) async {
    try {
      var data = {"id": id, "qry": body};
      print("Update order data -  $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/updateOrder');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      print("Update order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);
      print("Update order res -  $decodedRes2");

      return decodedRes2;
    } catch (e) {
      print("Update Order error - $e");
      return e;
    }
  }

  Future<void> addOrderItem(String orderId, dynamic body) async {
    try {
      var data = {"orderId": orderId, "body": body};
      print("add order item data -  $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/addOrderItem');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      print("add order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);
      print("add order res -  $decodedRes2");

      // return decodedRes2;
    } catch (e) {
      print("add Order error - $e");
      // return e;
    }
  }

  Future<dynamic> updateOrderItem(
      String orderId, String productId, dynamic body) async {
    try {
      // irderId: invoiceNumber
      var data = {"orderId": orderId, "productId": productId, "body": body};
      print("Update order item data -  $data");
      var uri = Math().ip();
      LocalStorage storage = LocalStorage('silkroute');
      var ut = await storage.getItem('userType');
      var route = (ut == 'Reseller') ? 'resellerApi' : 'manufacturerApi';
      var url = Uri.parse(uri + '/' + route + '/updateOrderItem');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      print("Update order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);
      print("Update order res -  $decodedRes2");

      return decodedRes2;
    } catch (e) {
      print("Update Order error - $e");
      return e;
    }
  }
}
