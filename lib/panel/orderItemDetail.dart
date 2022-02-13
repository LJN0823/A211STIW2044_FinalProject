import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/orderitem.dart';
import 'package:ndialog/ndialog.dart';

class OrDetailsPage extends StatefulWidget {
  final OrderItem oritem;
  const OrDetailsPage({Key? key, required this.oritem}) : super(key: key);

  @override
  State<OrDetailsPage> createState() => _OrDetailsPageState();
}

class _OrDetailsPageState extends State<OrDetailsPage> {
  late double screenHeight, screenWidth, resWidth;
  File? image;
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController descEC = TextEditingController();
  final TextEditingController priceEC = TextEditingController();
  final TextEditingController delfeeEC = TextEditingController();
  final TextEditingController quantityEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameEC.text = widget.oritem.prname.toString();
    descEC.text = widget.oritem.prdesc.toString();
    priceEC.text = widget.oritem.prprice.toString();
    delfeeEC.text = widget.oritem.prdelfee.toString();
    quantityEC.text = widget.oritem.oiquantity.toString();
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
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            IconButton(
                onPressed: _deleteBTN,
                icon: Icon(Icons.delete, size: resWidth * 0.06))
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
                child: SizedBox(
          width: resWidth,
          child: Column(children: [
            SizedBox(
                height: screenHeight / 2.5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: image == null
                          ? NetworkImage(MyConfig.server +
                              "/mypastry/images/products/" +
                              widget.oritem.prid.toString() +
                              ".png")
                          : FileImage(image!) as ImageProvider,
                      fit: BoxFit.fill,
                    ),
                  )),
                )),
            Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Form(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                            enabled: false,
                            controller: nameEC,
                            decoration: InputDecoration(
                                labelText: 'Product\'s Name',
                                labelStyle:
                                    TextStyle(fontSize: resWidth * 0.04),
                                icon: Icon(
                                  Icons.person,
                                  size: resWidth * 0.05,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            enabled: false,
                            maxLines: 4,
                            controller: descEC,
                            decoration: InputDecoration(
                                labelText: 'Product\'s Description',
                                alignLabelWithHint: true,
                                labelStyle:
                                    TextStyle(fontSize: resWidth * 0.04),
                                icon: Icon(Icons.chat, size: resWidth * 0.05),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            enabled: false,
                            controller: priceEC,
                            decoration: InputDecoration(
                                labelText: 'Product\'s Unit Price',
                                labelStyle:
                                    TextStyle(fontSize: resWidth * 0.04),
                                icon: Icon(Icons.money_sharp,
                                    size: resWidth * 0.05),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            enabled: false,
                            controller: quantityEC,
                            decoration: InputDecoration(
                                labelText: 'Product\'s Ordered Quantity',
                                labelStyle:
                                    TextStyle(fontSize: resWidth * 0.04),
                                icon: Icon(Icons.storefront,
                                    size: resWidth * 0.05),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            enabled: false,
                            controller: delfeeEC,
                            decoration: InputDecoration(
                                labelText: 'Delivery Fee',
                                labelStyle:
                                    TextStyle(fontSize: resWidth * 0.04),
                                icon: Icon(Icons.delivery_dining,
                                    size: resWidth * 0.05),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ],
                    ),
                  ),
                )),
          ]),
        ))));
  }

  void _deleteBTN() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Delete this order",
              style: TextStyle(fontSize: resWidth * 0.04)),
          content: Text("Are you sure to delete?",
              style: TextStyle(fontSize: resWidth * 0.035)),
          actions: [
            TextButton(
              child: Text("Yes", style: TextStyle(fontSize: resWidth * 0.035)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOrder();
              },
            ),
            TextButton(
              child: Text("No", style: TextStyle(fontSize: resWidth * 0.035)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder() {
    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Deleting order..",
            style: TextStyle(fontSize: resWidth * 0.04)),
        title:
            Text("Processing...", style: TextStyle(fontSize: resWidth * 0.35)));
    dialog.show();
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/deleteOrder.php"),
        body: {
          "prid": widget.oritem.prid,
          "oiquantity": widget.oritem.oiquantity
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Successfully deleted order",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: resWidth * 0.03);
        dialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to delete order",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: resWidth * 0.03);
        dialog.dismiss();
        return;
      }
    });
    dialog.dismiss();
  }
}
