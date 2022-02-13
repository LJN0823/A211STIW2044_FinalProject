import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class NewProductPage extends StatefulWidget {
  final User user;
  const NewProductPage({Key? key, required this.user}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late double screenHeight, screenWidth, resWidth;
  File? image;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController descEC = TextEditingController();
  final TextEditingController priceEC = TextEditingController();
  final TextEditingController delfeeEC = TextEditingController();
  final TextEditingController quantityEC = TextEditingController();

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
      appBar: AppBar(title: const Text("Add New Product")),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: resWidth,
            child: Column(
              children: [
                SizedBox(
                    height: screenHeight / 2.5,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                            decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image == null
                                ? const AssetImage("assets/images/camera.png")
                                : FileImage(image!) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        )),
                      ),
                    )),
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Product name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: nameEC,
                              decoration: InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon:
                                      Icon(Icons.person, size: resWidth * 0.08),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 3)
                                  ? "Product description must be longer than 3"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              maxLines: 4,
                              controller: descEC,
                              decoration: InputDecoration(
                                  labelText: 'Product Description',
                                  alignLabelWithHint: true,
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.chat, size: resWidth * 0.08),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Product price must contain value"
                                  : null,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: priceEC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Product Price',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.money_sharp,
                                      size: resWidth * 0.08),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
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
                                  labelText: 'Product Quantity',
                                  labelStyle:
                                      TextStyle(fontSize: resWidth * 0.04),
                                  icon: Icon(Icons.storefront,
                                      size: resWidth * 0.08),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
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
                                      size: resWidth * 0.08),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(resWidth / 2, resWidth * 0.1)),
                            child: Text('Add Product',
                                style: TextStyle(fontSize: resWidth * 0.04)),
                            onPressed: () => {
                              _newProductDialog(),
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  _newProductDialog() {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in all the required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Add this product",
            style: TextStyle(fontSize: resWidth * 0.04),
          ),
          content: Text("Are you sure?",
              style: TextStyle(fontSize: resWidth * 0.035)),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(fontSize: resWidth * 0.04),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addNewProduct();
              },
            ),
            TextButton(
              child: Text(
                "No",
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

  void _addNewProduct() {
    String name = nameEC.text;
    String desc = descEC.text;
    String price = priceEC.text;
    String quantity = quantityEC.text;
    String delfee = delfeeEC.text;
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();

    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Adding new product..",
            style: TextStyle(fontSize: resWidth * 0.35)),
        title:
            Text("Processing...", style: TextStyle(fontSize: resWidth * 0.04)));
    dialog.show();

    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/addProduct.php"),
        body: {
          "prname": name,
          "prdesc": desc,
          "prprice": price,
          "prquantity": quantity,
          "prdelfee": delfee,
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
}
