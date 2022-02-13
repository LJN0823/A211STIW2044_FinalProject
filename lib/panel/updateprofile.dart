import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  final User user;
  const UpdateProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late double screenHeight, screenWidth, resWidth = 0;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController phoneEC = TextEditingController();
  final TextEditingController emailEC = TextEditingController();
  final TextEditingController addEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameEC.text = widget.user.name.toString();
    phoneEC.text = widget.user.phone.toString();
    emailEC.text = widget.user.email.toString();
    addEC.text = widget.user.address.toString();
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
          title: const Text('Edit Profile'),
        ),
        body: Padding(
          padding: EdgeInsets.all(resWidth * 0.05),
          child: Center(
            child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: resWidth * 0.2,
                            child: Text("Name: ",
                                style: TextStyle(fontSize: resWidth * 0.04))),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Please enter valid name"
                                      : null,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: nameEC,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0)))),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: resWidth * 0.2,
                            child: Text("Phone: ",
                                style: TextStyle(fontSize: resWidth * 0.04))),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 10) ||
                                      (val.length > 11)
                                  ? "Please enter valid phone number"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              controller: phoneEC,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0)))),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: resWidth * 0.2,
                            child: Text("Email: ",
                                style: TextStyle(fontSize: resWidth * 0.04))),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Please enter valid email"
                                  : null,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: emailEC,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0)))),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: resWidth * 0.2,
                            child: Text("Address: ",
                                style: TextStyle(fontSize: resWidth * 0.04))),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 5)
                                  ? "Please enter valid address"
                                  : null,
                              focusNode: focus2,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus3);
                              },
                              controller: addEC,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0)))),
                        )
                      ],
                    ),
                    SizedBox(height: resWidth * 0.03),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(resWidth / 2, resWidth * 0.1)),
                      child: Text('Update Profile',
                          style: TextStyle(fontSize: resWidth * 0.04)),
                      onPressed: _updateProfileDialog,
                    ),
                  ]),
            ),
          ),
        ));
  }

  void _updateProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Update Your Profile",
            style: TextStyle(
                fontSize: resWidth * 0.05, fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure to change?",
              style: TextStyle(fontSize: resWidth * 0.035)),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(fontSize: resWidth * 0.035),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateProfile();
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyle(fontSize: resWidth * 0.035),
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

  void _updateProfile() {
    String name = nameEC.text;
    String phone = phoneEC.text;
    String email = emailEC.text;
    String address = addEC.text;
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog dialog = ProgressDialog(context,
        message: Text("Updating Profile..",
            style: TextStyle(fontSize: resWidth * 0.04)),
        title: Text("Processing...",
            style: TextStyle(fontSize: resWidth * 0.04)));
    dialog.show();

    http.post(Uri.parse(MyConfig.server + "/mypastry/php/updateProfile.php"),
        body: {
          "userid": widget.user.id,
          "name": name,
          "phone": phone,
          "email": email,
          "address": address,
          "loc": widget.user.loc
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        dialog.dismiss();
        setState(() {
          widget.user.name = name;
          widget.user.phone = phone;
          widget.user.email = email;
          widget.user.address = address;
        });
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        dialog.dismiss();
        return;
      }
    });
    dialog.dismiss();
  }
}
