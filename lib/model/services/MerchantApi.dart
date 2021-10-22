import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/OrderListItem.dart';
import 'package:silkroute/model/core/ProductList.dart';

class MerchantApi {
  LocalStorage storage = LocalStorage('silkroute');
  dynamic addNewProduct(product) async {
    try {
      print("Add new prodTuct $product");
      var data = product;
      print("Add new product $product");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/addProduct');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      var id = res.body.toString();
      print("resp: $id");
      // print("resp: ${decodedRes2[0].id}");
      return id;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future<List<OrderListItem>> getMerchantOrders(sortBy, filter) async {
    try {
      var data = {
        "contact": storage.getItem("contact"),
        "sortBy": sortBy,
        "filter": filter
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getMerchantOrders');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      var decodedRes2 = jsonDecode(res.body);
      print("mer orders: $decodedRes2");
      List<OrderListItem> resp = [];
      for (var i in decodedRes2) {
        print("mer order: $i");
        OrderListItem r = OrderListItem.fromMap(i);
        resp.add(r);
      }
      print("mer orders: $resp");
      return resp;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }
}
