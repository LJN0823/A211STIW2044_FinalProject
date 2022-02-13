import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:mypastry/panel/register.dart';
import 'package:http/http.dart' as http;
import 'package:mypastry/panel/updateProfile.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenHeight, screenWidth, resWidth;
  File? image;
  final picker = ImagePicker();
  var pathAsset = "assets/images/camera.png";
  late Position _currentPosition;
  String loc = "na";
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _permissionLoc();
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

    return Center(
      child: Column(children: [
        Flexible(
            flex: 4,
            child: Container(
              child: image == null
                  ? SizedBox(
                      height: screenHeight * 0.3,
                      child: SizedBox(
                          width: screenWidth / 2,
                          child: GestureDetector(
                            onTap: _selectImage,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: image == null
                                      ? NetworkImage(MyConfig.server +
                                          "/mypastry/images/profile/" +
                                          widget.user.id.toString() +
                                          ".png")
                                      : FileImage(image!) as ImageProvider,
                                  fit: BoxFit.fill,
                                ),
                              )),
                            ),
                          )),
                    )
                  : SizedBox(
                      height: screenWidth / 2,
                      width: screenWidth / 2,
                      child: GestureDetector(
                        onTap: _selectImage,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Container(
                              decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(image!) as ImageProvider,
                              fit: BoxFit.fill,
                            ),
                          )),
                        ),
                      )),
            )),
        SingleChildScrollView(
          child: Column(children: [
            Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
          child: Table(
            columnWidths: const {
              0: FractionColumnWidth(0.3),
              1: FractionColumnWidth(0.1),
              2: FractionColumnWidth(0.6)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: [
              TableRow(children: [
                Text("Name ",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(":",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(widget.user.name.toString(),
                    style: TextStyle(fontSize: resWidth * 0.05)),
              ]),
              TableRow(children: [
                Text("Phone",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(":",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(widget.user.phone.toString(),
                    style: TextStyle(fontSize: resWidth * 0.05)),
              ]),
              TableRow(children: [
                Text("Email",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(":",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(widget.user.email.toString(),
                    style: TextStyle(fontSize: resWidth * 0.05)),
              ]),
              TableRow(children: [
                Text("Locality",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(":",
                    style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold)),
                Text(widget.user.loc.toString(),
                    style: TextStyle(fontSize: resWidth * 0.05)),
              ]),
              widget.user.datereg.toString() == ""
                  ? TableRow(children: [
                      Text("Registered Date",
                          style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                      Text(":",
                          style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                      Text(
                          df.format(DateTime.parse(
                              widget.user.datereg.toString())),
                          style: TextStyle(fontSize: resWidth * 0.05)),
                    ])
                  : TableRow(children: [
                      Text("Registered Date",
                          style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                      Text(":",
                          style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                      Text(widget.user.datereg.toString(),
                          style: TextStyle(fontSize: resWidth * 0.05)),
                    ]),
              TableRow(children: [
                SizedBox(height: resWidth * 0.03),
                SizedBox(height: resWidth * 0.03),
                SizedBox(height: resWidth * 0.03),
              ]),
              TableRow(children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UpdateProfile(user: widget.user)))
                  },
                  child: Text("Edit",
                      style: TextStyle(
                        fontSize: resWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )),
                ),
                const Text(""),
                const Text("")
              ]),
            ],
          ),
            ),
            SizedBox(height: resWidth * 0.03),
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _changePassword,
              child: Text("Change Password",
                  style: TextStyle(fontSize: resWidth * 0.04)),
            ),
            SizedBox(width: resWidth * 0.03),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Register())),
              child: Text("Register",
                  style: TextStyle(fontSize: resWidth * 0.04)),
            ),
          ],
            ),
          ]),
        )
      ]),
    );
  }

  Future<void> _permissionLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openLocationSettings();
      } else {
        Navigator.of(context).pop();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openLocationSettings();
    }
    _getLoc();
  }

  Future<void> _getLoc() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    loc = placemarks[0].locality.toString();
    widget.user.loc = loc;
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
      String base64Image = base64Encode(image!.readAsBytesSync());
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/updateProfile.php"),
          body: {
            "image": base64Image,
            "userid": widget.user.id
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.green,
              fontSize: resWidth * 0.04);
          setState(() {
            image = croppedFile;
          });
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.red,
              fontSize: resWidth * 0.04);
        }
      });
    }
    setState(() {
      image = croppedFile;
    });
  }

  void _changePassword() {
    TextEditingController passEC = TextEditingController();
    TextEditingController pass2EC = TextEditingController();
    final focus = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Change Password",
              style: TextStyle(fontSize: resWidth * 0.04),
            ),
            content: SizedBox(
              height: screenHeight / 5,
              child: Column(
                children: [
                  Row(children: [
                    SizedBox(
                        width: resWidth * 0.2,
                        child: Text("New Password: ",
                            style: TextStyle(fontSize: resWidth * 0.04))),
                    Expanded(
                        child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) =>
                          val!.isEmpty ? "Please enter a password" : null,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      controller: passEC,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0))),
                      obscureText: true,
                    ))
                  ]),
                  Row(children: [
                    SizedBox(
                        width: resWidth * 0.2,
                        child: Text("Reenter New Password: ",
                            style: TextStyle(fontSize: resWidth * 0.04))),
                    Expanded(
                        child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) =>
                          val!.isEmpty ? "Please reenter the password!" : null,
                      focusNode: focus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: pass2EC,
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
                  "Confirm",
                  style: TextStyle(fontSize: resWidth * 0.04),
                ),
                onPressed: () {
                  if (passEC.text != pass2EC.text) {
                    Fluttertoast.showToast(
                        msg: "Incorrect reenter password!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: resWidth * 0.04);
                    return;
                  }
                  if (passEC.text.isEmpty || pass2EC.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please fill in the passwords",
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
                          MyConfig.server + "/mypastry/php/updateProfile.php"),
                      body: {
                        "password": passEC.text,
                        "userid": widget.user.id
                      }).then((response) {
                    var data = jsonDecode(response.body);
                    if (response.statusCode == 200 &&
                        data['status'] == 'success') {
                      Fluttertoast.showToast(
                          msg: "Success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.green,
                          fontSize: resWidth * 0.04);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Failed",
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
