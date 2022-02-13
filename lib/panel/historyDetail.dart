import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {
  final User user;
  final String orreceiptID;
  final String orid;
  const OrderDetailsPage(
      {Key? key, required this.user, required this.orreceiptID, required this.orid})
      : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late double screenHeight, screenWidth, reswidth;
  List orderlist = [];
  late ScrollController scrollController;
  int scrollcount = 5;
  int rowcount = 2;
  String titlecenter = "Loading History...";

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      reswidth = screenWidth;
    } else {
      reswidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Details Page'),
      ),
      body: orderlist.isEmpty
          ? Center(
              child: Column(children: [
                Text(titlecenter,
                    style: TextStyle(
                        fontSize: reswidth * 0.05,
                        fontWeight: FontWeight.bold)),
              ]),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "Total Paid RM " +
                          double.parse(orderlist[0]['orpaid'])
                              .toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: reswidth * 0.045,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    controller: scrollController,
                    childAspectRatio: 0.78,
                    children: List.generate(scrollcount, (index) {
                      return Card(
                          color: Colors.blue.shade100,
                          child: Column(
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl: MyConfig.server +
                                        "/mypastry/images/products/" +
                                        orderlist[index]['prid'].toString() +
                                        ".png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Text(
                                          _truncateString(orderlist[index]
                                                  ['prname']
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: reswidth * 0.04,
                                              fontWeight: FontWeight.bold)),
                                      //SizedBox(height: reswidth * 0.015),
                                      Text(
                                          "RM " +
                                              double.parse(orderlist[index]
                                                          ['prprice']
                                                      .toString())
                                                  .toStringAsFixed(2) +
                                              " per unit",
                                          style: TextStyle(
                                              fontSize: reswidth * 0.04)),
                                      //SizedBox(height: reswidth * 0.015),
                                      Text(
                                          orderlist[index]['oiquantity']
                                                  .toString() +
                                              " unit ordered",
                                          style: TextStyle(
                                              fontSize: reswidth * 0.04)),
                                    ],
                                  )),
                            ],
                          ));
                    }),
                  ),
                )
              ],
            ),
    );
  }

  String _truncateString(String string) {
    if (string.length > 15) {
      string = string.substring(0, 15);
      return string + "...";
    } else {
      return string;
    }
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

  void _loadOrder() {
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadHistory.php"),
        body: {"orreceiptID": widget.orreceiptID,
        "id": widget.user.id, "orid": widget.orid}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        setState(() {
          orderlist = extractdata["orders"];
          if (scrollcount >= orderlist.length) {
            scrollcount = orderlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Order Yet.";
        });
      }
    });
  }
}
