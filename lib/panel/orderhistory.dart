import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:mypastry/panel/historyDetail.dart';

class HistoryPage extends StatefulWidget {
  final User user;
  const HistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List orderlist = [];
  String titlecenter = "Loading History...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController scrollController;
  int scrollcount = 5;
  int rowcount = 2;
  final df = DateFormat('dd/MM/yyyy hh:mm a');

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
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders History'),
      ),
      body: orderlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: TextStyle(
                      fontSize: resWidth * 0.05, fontWeight: FontWeight.bold)),
            )
          : GridView.count(
              crossAxisCount: rowcount,
              controller: scrollController,
              children: List.generate(scrollcount, (index) {
                return Card(
                  elevation: 4.0,
                    color: Colors.blue.shade100,
                    child: InkWell(
                      onTap: () => {_orDetail(index)},
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.02),
                              Text("Order Receipt ID : ",
                                  style: TextStyle(
                                      fontSize: resWidth * 0.04,
                                      fontWeight: FontWeight.bold)),
                              Text(orderlist[index]['orreceiptID'].toString(),
                                  style: TextStyle(
                                      fontSize: resWidth * 0.05,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                  "Total Amount: RM " +
                                      double.parse(orderlist[index]['orpaid'])
                                          .toStringAsFixed(2),
                                  style: TextStyle(fontSize: resWidth * 0.035)),
                              SizedBox(height: resWidth * 0.015),
                              Text(
                                  "Order Status: " +
                                      orderlist[index]['orstatus'],
                                  style: TextStyle(fontSize: resWidth * 0.035)),
                                  SizedBox(height: resWidth * 0.015),
                              Text(
                                  df.format(DateTime.parse(
                                      orderlist[index]['ordate'])),
                                  style: TextStyle(
                                    fontSize: resWidth * 0.035,
                                  )),
                                  SizedBox(height: resWidth * 0.015),
                              Text("Click to view details",
                                  style: TextStyle(
                                      fontSize: resWidth * 0.04,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ));
              }),
            ),
    );
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        if (orderlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= orderlist.length) {
            scrollcount = orderlist.length;
          }
        }
      });
    }
  }

  void _loadOrder() {
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadHistory.php"),
        body: {"id": widget.user.id}).then((response) {
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
          titlecenter = "No History Yet.";
        });
      }
    });
  }

  _orDetail(int index) async {
    String orreceiptID = orderlist[index]['orreceiptID'].toString();
    String orid = orderlist[index]['orid'].toString();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderDetailsPage(orreceiptID: orreceiptID, user: widget.user, orid: orid,)));
  }
}
