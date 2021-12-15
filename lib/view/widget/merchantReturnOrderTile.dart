import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
// import 'package:silkroute/view/pages/reseller/order_page.dart';
// import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class MerchantReturnOrderTile extends StatefulWidget {
  const MerchantReturnOrderTile({Key key, this.orders}) : super(key: key);
  final dynamic orders;

  @override
  _MerchantOrderTileState createState() => _MerchantOrderTileState();
}

class _MerchantOrderTileState extends State<MerchantReturnOrderTile> {
  bool loading = true;
  List<dynamic> orders = [], _status;
  Icon icon;

  Future<void> confirmOrder(int index, dynamic body) async {
    var res = await OrderApi().updateOrderItem(
        widget.orders[index].orderId, widget.orders[index].productId, body);

    // ignore: todo
    //TODO: createShipRocketOrder

    if (res['success'] == true) {
      if (orders[index]['merchantStatus'] == "Not Seen") {
        setState(() {
          orders[index]['merchantStatus'] = "Not Ready";
        });
      } else {
        setState(() {
          orders[index]['merchantStatus'] = "Ready";
        });
      }
    } else {
      Toast().notifyErr("Error Occurred, Please try again");
    }
  }

  void loadVars() {
    // print("order list item ${widget.orders}");
    setState(() {
      for (var order in widget.orders) {
        orders.add(order.toMap());
      }
      _status = [
        "By accepting this, you confirm that you have seen order and started working on it.",
        "By accepting this, you confirm that your order is completed and ready to be shipped."
      ];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int i) {
              dynamic date =
                  orders[i]['refund']['requestedDate'].toString().split(":");
              print(date);
              dynamic left = date[0].split("T");
              dynamic reqDate = left[0] + " " + left[1] + ":" + date[1];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                                id: (orders[i]['productId']).toString()),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/1.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                      id: (orders[i]['productId']).toString()),
                                ),
                              );
                            },
                            child: Text(
                              orders[i]['title'],
                              style: textStyle(12, Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: orders[i]['colors'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 20,
                                  height: 20,
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      // image: NetworkImage(Math().ip() +
                                      //     "/images/616ff5ab029b95081c237c89-color-0"),
                                      image: NetworkImage(
                                          "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            "Quantity: ${orders[i]['quantity']}",
                            style: textStyle(12, Colors.black45),
                          ),
                          Text(
                            "Request Date: $reqDate",
                            style: textStyle(12, Colors.black45),
                          ),
                          Text(
                            "Your Status: ${orders[i]['merchantStatus']}",
                            style: textStyle(12, Colors.black45),
                          ),
                          Text(
                            "Pay Status: " + orders[i]['merchantPaymentStatus'],
                            style: textStyle(12, Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {},
                          icon: Icon(CupertinoIcons.money_dollar),
                        ),
                        Text("Pay")
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  void showConfirmationAlert(int i, dynamic body, int status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
          title: Text(
            _status[status],
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color(0xFF5B0D1B),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text(
                "Confirm",
                style: textStyle(15, Color(0xFF5B0D1B)),
              ),
              onTap: () async {
                await confirmOrder(i, body);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Text(
                "Cancel",
                style: textStyle(15, Color(0xFF5B0D1B)),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
  }
}
