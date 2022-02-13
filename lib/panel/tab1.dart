import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/orderitem.dart';
import 'package:mypastry/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:mypastry/panel/OwnerOrDetail.dart';
import 'package:mypastry/panel/bill.dart';
import 'package:mypastry/panel/orderItemDetail.dart';
import 'package:mypastry/panel/orderhistory.dart';
import 'package:mypastry/panel/tab3.dart';

class OrderPage extends StatefulWidget {
  final User user;
  const OrderPage({Key? key, required this.user}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late double screenWidth, screenHeight, resWidth;
  bool owner = false;
  List orderlist = [];
  int totalorder = 0;
  late ScrollController scrollController;
  int scrollcount = 5;
  String titlecenter = "Loading order...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    if (int.parse(widget.user.phone.toString()) == 0172582622) {
      owner = true;
    }
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: orderlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: TextStyle(
                      fontSize: resWidth * 0.05, fontWeight: FontWeight.bold)),
            )
          : _tab3Page(context),
      floatingActionButton: Visibility(
        visible: !owner,
        child: SpeedDial(
          visible: !owner,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.receipt_long),
                label: "View Order History",
                labelStyle: const TextStyle(color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: _orderHistory),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        if (orderlist.length > scrollcount) {
          scrollcount = scrollcount + 5;
          if (scrollcount >= orderlist.length) {
            scrollcount = orderlist.length;
          }
        }
      });
    }
  }

  void _loadOrders() {
    if (widget.user.address == "na") {
      setState(() {
        titlecenter = "Please provide your address at profile page before buy the products.";
      });
      return;
    }
    if (!owner) {
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadOrder.php"),
          body: {"id": widget.user.id}).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          var extractdata = data['data'];
          setState(() {
            orderlist = extractdata["orders"];
            totalorder = orderlist.length;
            if (scrollcount >= orderlist.length) {
              scrollcount = orderlist.length;
            }
          });
        } else {
          setState(() {
            titlecenter = "No order Yet.";
          });
        }
      });
    } else {
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadHistory.php"),
          body: {}).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          var extractdata = data['data'];
          setState(() {
            orderlist = extractdata["orders"];
            totalorder = orderlist.length;
            if (scrollcount >= orderlist.length) {
              scrollcount = orderlist.length;
            }
          });
        } else {
          setState(() {
            titlecenter = "No customer order Yet.";
          });
        }
      });
    }
  }

  String truncateString(String string) {
    if (string.length > 15) {
      string = string.substring(0, 15);
      return string + "...";
    } else {
      return string;
    }
  }

  _orDetail(int index) {
    if (owner) {
      String orreceiptID = orderlist[index]['orreceiptID'].toString();
      String orid = orderlist[index]['orid'].toString();
      String orstatus = orderlist[index]['orstatus'].toString();
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => 
                OwnerOrderDetailsPage(orstatus:orstatus, orid:orid, orreceiptID: orreceiptID ,user: widget.user)));
    setState(() {
      _loadOrders();
      orderlist = orderlist;
    });
    } else {
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadOrder.php"),
        body: {"prid": orderlist[index]['prid']}).then((response) async {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        OrderItem oritem = OrderItem.fromJson(extractdata);
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrDetailsPage(oritem: oritem)));
      }
    });
    }
  }

  void _payOrder() {
    double amount =
        double.parse(orderlist[0]['prdelfee']); //delicvery fee only cahrge once

    for (int i = 0; i < totalorder; i++) {
      amount = amount +
          double.parse(orderlist[i]['prprice']) *
              double.parse(orderlist[i]['oiquantity']);
    }

    if (widget.user.email == "na") {
      AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(
          "Please provide your email in profile page first!",
          style: TextStyle(
              fontSize: resWidth * 0.045, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(fontSize: resWidth * 0.04),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProfilePage(user: widget.user)));
            },
          ),
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: resWidth * 0.04),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Confirm to process payment?",
            style: TextStyle(
                fontSize: resWidth * 0.045, fontWeight: FontWeight.bold),
          ),
          content: Text("Total Amount RM " + amount.toStringAsFixed(2),
              style: TextStyle(fontSize: resWidth * 0.04)),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(fontSize: resWidth * 0.04),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => BillPage(
                              user: widget.user,
                              amount: amount,
                            )));
                _loadOrders();
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: resWidth * 0.04),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _orderHistory() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HistoryPage(user: widget.user)));
  }

  _tab3Page(BuildContext context) {
    if (owner) {
      return Column(
        children: [
          SizedBox(
            height: screenHeight / 9.9,
            child: Row(
              children: [
                SizedBox(
                  width: resWidth * 0.4,
                  child: Text(" Order Receipt ID",
                      style: TextStyle(fontSize: resWidth * 0.04)),
                ),
                SizedBox(
                  width: resWidth * 0.25,
                  child: Text("Total Price",
                      style: TextStyle(fontSize: resWidth * 0.04)),
                ),
                SizedBox(
                  width: resWidth * 0.3,
                  child: Text("Status ",
                      style: TextStyle(fontSize: resWidth * 0.04)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: scrollcount,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                        onTap: () => {_orDetail(index)},
                    leading: SizedBox(
                      width: resWidth * 0.35,
                      child: Text(orderlist[index]['orreceiptID'].toString(),
                          style: TextStyle(fontSize: resWidth * 0.04)),
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: resWidth * 0.2,
                          child: Text(double.parse(orderlist[index]['orpaid'])
                                      .toStringAsFixed(2),
                              style: TextStyle(fontSize: resWidth * 0.04)),
                        ),
                        SizedBox(
                          width: resWidth * 0.2,
                          child: Text(orderlist[index]['orstatus'].toString(),
                              style: TextStyle(fontSize: resWidth * 0.04)),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ));
                }),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Current Orders",
                style: TextStyle(
                    fontSize: resWidth * 0.04, fontWeight: FontWeight.bold)),
          ),
          Text(totalorder.toString() + " orders in list"),
          Expanded(
            child: ListView.builder(
                itemCount: scrollcount,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 4,
                      color: Colors.blue.shade100,
                      child: Container(
                        height: screenHeight / 9,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () => {_orDetail(index)},
                          child: ListTile(
                            leading: CachedNetworkImage(
                              width: resWidth * 0.2,
                              height: resWidth * 0.3,
                              imageUrl: MyConfig.server +
                                  "/mypastry/images/products/" +
                                  orderlist[index]['prid'] +
                                  ".png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(
                                truncateString(
                                    orderlist[index]['prname'].toString()),
                                style: TextStyle(
                                    fontSize: resWidth * 0.045,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                orderlist[index]['oiquantity'] +
                                    " quantity ordered",
                                style: TextStyle(fontSize: resWidth * 0.04)),
                          ),
                        ),
                      ));
                }),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(resWidth / 2, resWidth * 0.1)),
            child: Text('Buy this Order',
                style: TextStyle(fontSize: resWidth * 0.04)),
            onPressed: _payOrder,
          ),
        ],
      );
    }
  }
}
