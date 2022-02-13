
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypastry/class/myconfig.dart';

import 'package:mypastry/class/user.dart';
import 'package:mypastry/panel/login.dart';
import 'package:mypastry/panel/register.dart';
import 'package:ndialog/ndialog.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  final User user;
  const OtpPage({Key? key, required this.user}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late double screenWidth, screenHeight, resWidth;
  final TextEditingController msgEC = TextEditingController();
  final TextEditingController phoneEC = TextEditingController();
  final TextEditingController valueEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    phoneEC.text = widget.user.phone.toString();
    msgEC.text = "Your Verification Code is " + widget.user.otp.toString();
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
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [upperHalf(context), lowerHalf(context)],
          ),
        ),
      ),
    ));
  }

  upperHalf(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(children: [
          GestureDetector(
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Register()))
            },
            child: SizedBox(
              width: resWidth,
              child: Text(
                "\t Back to Register Page",
                style: TextStyle(
                    fontSize: resWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: resWidth * 0.2,
          ),
          SizedBox(
              height: screenHeight / 10,
              width: resWidth * 0.75,
              child: Text("Verify Your Account",
                  style: TextStyle(
                      fontSize: resWidth * 0.06, fontWeight: FontWeight.bold)))
        ]));
  }

  lowerHalf(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width: resWidth * 0.45,
                      child: Text("Your Phone Number : ",
                          style: TextStyle(fontSize: resWidth * 0.04))),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: phoneEC,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: valueEC,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 5) {
                    return 'Please check your phone message again';
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter verification code',
                  labelText: 'Pin number',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => _sendSMS(), child: const Text('Send Code')),
            ElevatedButton(
                onPressed: () => _verifyDialog(),
                child: const Text('Verify Account')),
          ],
        ),
      ),
    );
  }

  _sendSMS() async {
    await telephony.sendSms(to: phoneEC.text, message: msgEC.text);
    _getSMS();
  }

  _getSMS() async {
    await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(phoneEC.text));
  }

  _verifyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            'Verify account?',
            style: TextStyle(fontSize: resWidth * 0.04),
          ),
          content: Text("Sure to Verify?",
              style: TextStyle(fontSize: resWidth * 0.04)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _varifyAccount();
                },
                child:
                    Text("Yes", style: TextStyle(fontSize: resWidth * 0.04))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No", style: TextStyle(fontSize: resWidth * 0.04))),
          ],
        );
      },
    );
  }

  void _varifyAccount() {
    String phone = widget.user.phone.toString();
    String otp = valueEC.text.toString();
    ProgressDialog dialog = ProgressDialog(context,
        message:
            Text("Please wait...", style: TextStyle(fontSize: resWidth * 0.04)),
        title: Text("Verify Account",
            style: TextStyle(fontSize: resWidth * 0.04)));
    dialog.show();
    http.post(Uri.parse(MyConfig.server + "/mypastry/php/verifyAccount.php"),
        body: {"phone": phone, "otp": otp}).then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        Fluttertoast.showToast(
            msg: "Successful Verify!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Login()));
      } else {
        Fluttertoast.showToast(
            msg: "Verify Failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: resWidth * 0.04);
        dialog.dismiss();
      }
    });
  }
}
