import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/product.dart';
import 'package:mypastry/class/user.dart';
import 'package:mypastry/panel/addProduct.dart';
import 'package:mypastry/panel/productDetail.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final User user;
  const ProductPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List productlist = [];
  String title =
      "This is home made pastry only sell for customers who live around Pekan Nanas, Johor. Thanks for viewing~";
  String titlecenter = "Loading Products...";
  late double screenHeight, screenWidth, reswidth;
  late ScrollController scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  bool owner = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _loadProducts();
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
    if (int.parse(widget.user.phone.toString()) == 0172582622) {
      owner = true;
    }
  
    return Scaffold(
        body: productlist.isEmpty
            ? Center(
                child: Column(children: [
                  Text(title, style: TextStyle(fontSize: reswidth * 0.045)),
                  SizedBox(height: reswidth * 0.2),
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
                    child: Text(title,
                        style: TextStyle(
                          fontSize: reswidth * 0.045,
                        )),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      controller: scrollController,
                      childAspectRatio: 0.78,
                      children: List.generate(scrollcount, (index) {
                        return Card(
                            color: Colors.blue.shade100,
                            child: InkWell(
                              onTap: () => {_prDetail(index)},
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
                                            productlist[index]['prid'] +
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
                                              _truncateString(productlist[index]
                                                      ['prname']
                                                  .toString()),
                                              style: TextStyle(
                                                  fontSize: reswidth * 0.05,
                                                  fontWeight: FontWeight.bold)),
                                          //SizedBox(height: reswidth * 0.015),
                                          Text(
                                              "RM " +
                                                  double.parse(
                                                          productlist[index]
                                                              ['prprice'])
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: reswidth * 0.04)),
                                          //SizedBox(height: reswidth * 0.015),
                                          Text(
                                              productlist[index]['prquantity'] +
                                                  " available now",
                                              style: TextStyle(
                                                  fontSize: reswidth * 0.04)),
                                        ],
                                      )),
                                ],
                              ),
                            ));
                      }),
                    ),
                  )
                ],
              ),
        floatingActionButton: Visibility(
            visible: owner,
            child: SpeedDial(
              visible: owner,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.add),
                    label: "New Product",
                    labelStyle: const TextStyle(color: Colors.black),
                    labelBackgroundColor: Colors.white,
                    onTap: _newProduct),
              ],
            )));
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }

  void _loadProducts() {
    if (widget.user.loc == "na" || widget.user.loc != "Pekan Nanas") {
      setState(() {
        titlecenter = "Please verify your location in profile page.";
      });
      return;
    }
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadProduct.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Product Yet.";
        });
      }
    });
  }

  _prDetail(int index) {
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/loadProduct.php"),
        body: {"prid": productlist[index]['prid']}).then((response) async {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        Product product = Product.fromJson(extractdata);
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PrDetailsPage(product: product, user: widget.user)));
        _loadProducts();
      }
    });
  }

  String _truncateString(String string) {
    if (string.length > 15) {
      string = string.substring(0, 15);
      return string + "...";
    } else {
      return string;
    }
  }

  Future<void> _newProduct() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NewProductPage(user: widget.user)));
    productlist = [];
    _loadProducts();
  }
}