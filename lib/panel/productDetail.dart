import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/product.dart';
import 'package:mypastry/class/user.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class PrDetailsPage extends StatefulWidget {
  final Product product;
  final User user;
  const PrDetailsPage({Key? key, required this.product, required this.user})
      : super(key: key);

  @override
  State<PrDetailsPage> createState() => _PrDetailsPageState();
}

class _PrDetailsPageState extends State<PrDetailsPage> {
  late double screenHeight, screenWidth, resWidth;
  bool owner = false, editpr = false;
  File? image;
  final picker = ImagePicker();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController descEC = TextEditingController();
  final TextEditingController priceEC = TextEditingController();
  final TextEditingController delfeeEC = TextEditingController();
  final TextEditingController quantityEC = TextEditingController();
  final TextEditingController dateEC = TextEditingController();
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String date = "";

  @override
  void initState() {
    super.initState();
    nameEC.text = widget.product.prname.toString();
    descEC.text = widget.product.prdesc.toString();
    priceEC.text = widget.product.prprice.toString();
    delfeeEC.text = widget.product.prdelfee.toString();
    quantityEC.text = widget.product.prquantity.toString();
    date = df.format(DateTime.parse(widget.product.prdate.toString()));
    dateEC.text = date;
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
    if (int.parse(widget.user.phone.toString()) == 0172582622) {
      owner = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            Visibility(
              visible: owner,
              child: IconButton(
                  onPressed: _deleteBTN,
                  icon: Icon(Icons.delete, size: resWidth * 0.06)),
            ),
            Visibility(
                visible: owner,
                child: IconButton(
                    onPressed: _editBTN,
                    icon: Icon(Icons.edit, size: resWidth * 0.06)))
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
                child: SizedBox(
          width: resWidth,
          child: Column(
            children: [
              editpr
                  ? SizedBox(
                      height: screenHeight / 2.5,
                      child: GestureDetector(
                        onTap: _selectImage,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                          child: Container(
                              decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image == null
                                  ? NetworkImage(MyConfig.server +
                                      "/mypastry/images/products/" +
                                      widget.product.prid.toString() +
                                      ".png")
                                  : FileImage(image!) as ImageProvider,
                              fit: BoxFit.fill,
                            ),
                          )),
                        ),
                      ))
                  : SizedBox(
                      height: screenHeight / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                        child: Container(
                            decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image == null
                                ? NetworkImage(MyConfig.server +
                                    "/mypastry/images/products/" +
                                    widget.product.prid.toString() +
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
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: editpr,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Name must be longer than 3 words"
                                      : null,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: nameEC,
                              decoration: InputDecoration(
                                  labelText: 'Product\'s Name',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(
                                    Icons.person,
                                    size: resWidth * 0.03,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: editpr,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 3)
                                  ? "Description must be longer than 3 words"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              maxLines: 4,
                              controller: descEC,
                              decoration: InputDecoration(
                                  labelText: 'Product\'s Description',
                                  alignLabelWithHint: true,
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.chat, size: resWidth * 0.03),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: editpr,
                              validator: (val) =>
                                  val!.isEmpty ? "Please insert price" : null,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: priceEC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Product\'s Price',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.money_sharp,
                                      size: resWidth * 0.03),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: editpr,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be more than 0"
                                  : null,
                              focusNode: focus2,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus3);
                              },
                              controller: quantityEC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Product\'s Quantity',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.storefront,
                                      size: resWidth * 0.03),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: editpr,
                              validator: (val) => val!.isEmpty
                                  ? "Must be more than zero"
                                  : null,
                              focusNode: focus3,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus4);
                              },
                              controller: delfeeEC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Delivery Fee',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.delivery_dining,
                                      size: resWidth * 0.03),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          /* for date */ 
                          TextFormField(
                              enabled: false,
                              controller: dateEC,
                              decoration: InputDecoration(
                                  labelText: 'Upload Date',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.calendar_today,
                                      size: resWidth * 0.03),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          Visibility(
                            visible: editpr,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize:
                                      Size(resWidth / 2, resWidth * 0.1)),
                              child: Text('Update Product',
                                  style: TextStyle(fontSize: resWidth * 0.04)),
                              onPressed: _updateProductDialog,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Visibility(
                            visible: !owner,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize:
                                      Size(resWidth / 2, resWidth * 0.1)),
                              child: Text('Add to Order',
                                  style: TextStyle(fontSize: resWidth * 0.04)),
                              onPressed: _buyProduct,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ))));
  }

  void _editBTN() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Edit this product",
                style: TextStyle(fontSize: resWidth * 0.04)),
            content: Text("Are you want to change the product?",
                style: TextStyle(fontSize: resWidth * 0.035)),
            actions: <Widget>[
              TextButton(
                child:
                    Text("Yes", style: TextStyle(fontSize: resWidth * 0.035)),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    editpr = true;
                  });
                },
              ),
              TextButton(
                  child:
                      Text("No", style: TextStyle(fontSize: resWidth * 0.035)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _deleteBTN() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Delete this product",
              style: TextStyle(fontSize: resWidth * 0.04)),
          content: Text("Are you sure to delete?",
              style: TextStyle(fontSize: resWidth * 0.035)),
          actions:[
            TextButton(
              child: Text("Yes", style: TextStyle(fontSize: resWidth * 0.035)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct();
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

  void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Select image from",
                style: TextStyle(fontSize: resWidth * 0.05)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(resWidth * 0.25, resWidth * 0.25)),
                    child: Text('Gallery',
                        style: TextStyle(fontSize: resWidth * 0.035)),
                    onPressed: () => {Navigator.of(context).pop(), _gallery()}),
                SizedBox(width: resWidth * 0.04),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(resWidth * 0.25, resWidth * 0.25)),
                    child: Text('Camera',
                        style: TextStyle(fontSize: resWidth * 0.035)),
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _camera(),
                        })
              ],
            ));
      },
    );
  }

  void _deleteProduct() {
    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Deleting product..",
            style: TextStyle(fontSize: resWidth * 0.04)),
        title:
            Text("Processing...", style: TextStyle(fontSize: resWidth * 0.35)));
    dialog.show();
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/deleteProduct.php"),
        body: {"prid": widget.product.prid}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: resWidth * 0.03);
        dialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
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

  void _updateProductDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Update this product",
                style: TextStyle(fontSize: resWidth * 0.04)),
            content: Text("Are you sure to change this product?",
                style: TextStyle(fontSize: resWidth * 0.04)),
            actions: [
              TextButton(
                  child:
                      Text("Yes", style: TextStyle(fontSize: resWidth * 0.04)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updateProduct();
                  }),
              TextButton(
                  child:
                      Text("No", style: TextStyle(fontSize: resWidth * 0.04)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _updateProduct() {
    String prname = nameEC.text;
    String prdesc = descEC.text;
    String prprice = priceEC.text;
    String prquantity = quantityEC.text;
    String prdelfee = delfeeEC.text;
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Updating product..",
            style: TextStyle(fontSize: resWidth * 0.04)),
        title:
            Text("Processing...", style: TextStyle(fontSize: resWidth * 0.04)));
    dialog.show();
    if (image == null) {
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/updateProduct.php"),
          body: {
            "prid": widget.product.prid,
            "prname": prname,
            "prdesc": prdesc,
            "prprice": prprice,
            "prquantity": prquantity,
            "prdelfee": prdelfee,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: resWidth * 0.035);
          dialog.dismiss();
          Navigator.of(context).pop();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: resWidth * 0.035);
          dialog.dismiss();
          return;
        }
      });
    } else {
      String base64Image = base64Encode(image!.readAsBytesSync());
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/updateProduct.php"),
          body: {
            "prid": widget.product.prid,
            "prname": prname,
            "prdesc": prdesc,
            "prprice": prprice,
            "prquantity": prquantity,
            "prdelfee": prdelfee,
            "image": base64Image,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: resWidth * 0.035);
          dialog.dismiss();
          Navigator.of(context).pop();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: resWidth * 0.035);
          dialog.dismiss();
          return;
        }
      });
    }
    dialog.dismiss();
  }

  _gallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      image = File(pickedFile.path);
      _cropImage();
    }
  }

  _camera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.square],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      image = croppedFile;
      setState(() {});
    }
  }
  void _buyProduct() {
    TextEditingController qtyEC = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: Text(
              "Quantity to buy",
              style: TextStyle(fontSize: resWidth * 0.04),
            ),
            content: SizedBox(
              height: screenHeight / 8,
              child: Column(
                children: [
                  Row(children: [
                    SizedBox(
                        width: resWidth * 0.2,
                        child: Text("Quantity: ",
                            style: TextStyle(fontSize: resWidth * 0.04))),
                    Expanded(
                        child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) =>
                          val!.isEmpty ? "Please enter a value" : null,
                      controller: qtyEC,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0))),
                      obscureText: true,
                    ))
                  ]),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: resWidth * 0.04),
                ),
                onPressed: () {
                  if (qtyEC.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please fill in the quantity",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: resWidth * 0.03);
                    return;
                  }
                  if (int.parse(qtyEC.text) > int.parse(widget.product.prquantity.toString())) {
                    Fluttertoast.showToast(
                        msg: "The quantity is out of stock",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: resWidth * 0.03);
                    return;
                  }
                  Navigator.of(context).pop();
                  http.post(
                      Uri.parse(
                          MyConfig.server + "/mypastry/php/addOrder.php"),
                      body: {
                        "quantity": qtyEC.text,
                        "prid": widget.product.prid,
                        "prprice": widget.product.prprice,
                        "id": widget.user.id,
                      }).then((response) {
                    var data = jsonDecode(response.body);
                    if (response.statusCode == 200 &&
                        data['status'] == 'success') {
                      Fluttertoast.showToast(
                          msg: "Successfully added",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.green,
                          fontSize: resWidth * 0.04);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Failed to add",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.red,
                          fontSize: resWidth * 0.04);
                    }
                  });
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
            ]);
      },
    );
  }
}
