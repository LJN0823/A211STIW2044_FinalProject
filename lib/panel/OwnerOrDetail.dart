import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class OwnerOrderDetailsPage extends StatefulWidget {
  final User user;
  final String orreceiptID;
  final String orid;
  final String orstatus;
  const OwnerOrderDetailsPage(
      {Key? key,
      required this.user,
      required this.orreceiptID,
      required this.orid,
      required this.orstatus})
      : super(key: key);

  @override
  State<OwnerOrderDetailsPage> createState() => _OwnerOrderDetailsPageState();
}

class _OwnerOrderDetailsPageState extends State<OwnerOrderDetailsPage> {
  late double screenHeight, screenWidth, reswidth;
  List orderlist = [];
  String titlecenter = "Loading Order...";

  @override
  void initState() {
    super.initState();
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
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details Page'),
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
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.2),
                              1: FractionColumnWidth(0.1),
                              2: FractionColumnWidth(0.7)
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.top,
                            children: [
                              TableRow(children: [
                                Text("Name ",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(":",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.user.name.toString(),
                                    style:
                                        TextStyle(fontSize: reswidth * 0.04)),
                              ]),
                              TableRow(children: [
                                Text("Phone",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(":",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.user.phone.toString(),
                                    style:
                                        TextStyle(fontSize: reswidth * 0.04)),
                              ]),
                              TableRow(children: [
                                Text("Address",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(":",
                                    style: TextStyle(
                                        fontSize: reswidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.user.address.toString(),
                                    style:
                                        TextStyle(fontSize: reswidth * 0.04)),
                              ]),
                            ],
                          ),
                        ),
                        Text(
                            "Order Receipt ID : " +
                                widget.orreceiptID.toString(),
                            style: TextStyle(
                                fontSize: reswidth * 0.05,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: reswidth * 0.03),
                        Table(
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: FractionColumnWidth(0.5),
                            1: FractionColumnWidth(0.35)
                          },
                          children: [
                            TableRow(children: [
                              Text("\tName ",
                                  style: TextStyle(
                                      fontSize: reswidth * 0.05,
                                      fontWeight: FontWeight.bold)),
                              Text("\tQuantity ",
                                  style: TextStyle(
                                      fontSize: reswidth * 0.05,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            for (var item in orderlist)
                              TableRow(children: [
                                Text("\t" + item['prname'].toString(),
                                    style:
                                        TextStyle(fontSize: reswidth * 0.05)),
                                Text("\t" + item['oiquantity'].toString(),
                                    style:
                                        TextStyle(fontSize: reswidth * 0.05)),
                              ]),
                          ],
                        ),
                        SizedBox(height: reswidth * 0.05),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(reswidth / 2, reswidth * 0.1)),
                          child: Text(widget.orstatus.toString(),
                              style: TextStyle(fontSize: reswidth * 0.04)),
                          onPressed: _updateStatusDialog,
                        ),
                      ]),
                ),
              ));
  }

  void _loadOrder() {
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadHistory.php"),
        body: {"id": widget.user.id, "orid": widget.orid}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        setState(() {
          orderlist = extractdata["orders"];
        });
      } else {
        setState(() {
          titlecenter = "Error";
        });
      }
    });
  }

  void _updateStatusDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Update status order?",
                style: TextStyle(fontSize: reswidth * 0.04)),
            content: Text("Are you sure to update?",
                style: TextStyle(fontSize: reswidth * 0.04)),
            actions: [
              TextButton(
                  child:
                      Text("Yes", style: TextStyle(fontSize: reswidth * 0.04)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updateStatus();
                  }),
              TextButton(
                  child:
                      Text("No", style: TextStyle(fontSize: reswidth * 0.04)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _updateStatus() {
    String newstatus = "";
    if (widget.orstatus.toString() == "Delivering") {
      newstatus = "Delivered";
    } else if (widget.orstatus.toString() == "Delivered") {
      newstatus = "Delivering";
    }

    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Updating product..",
            style: TextStyle(fontSize: reswidth * 0.04)),
        title:
            Text("Processing...", style: TextStyle(fontSize: reswidth * 0.04)));
    dialog.show();
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/updateStatus.php"),
        body: {
          "orreceiptID": widget.orreceiptID,
          "newstatus": newstatus
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Successfully Changed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: reswidth * 0.035);
        dialog.dismiss();
        Navigator.of(context).pop();
        setState(() {});
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: reswidth * 0.035);
        dialog.dismiss();
        return;
      }
    });
    dialog.dismiss();
  }
}
