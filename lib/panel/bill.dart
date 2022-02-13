import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillPage extends StatefulWidget {
  final User user;
  final double amount;
  const BillPage({Key? key, required this.user, required this.amount})
      : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late double screenHeight, screenWidth, resWidth;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  String ipcon = MyConfig.server;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
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
        title: const Text('Bill Page'),
      ),
      body: Center(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: WebView(
            initialUrl: MyConfig.server +
                '/mypastry/php/payment.php?phone=' +
                widget.user.phone.toString() +
                '&userid=' +
                widget.user.id.toString() +
                '&name=' +
                widget.user.name.toString() +
                '&amount=' +
                widget.amount.toString() +
                '&email=' +
                widget.user.email.toString()+
                '&myconf=' +
                ipcon,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            //onProgress: (int progress) {
            //  print('WebView is loading (progress : $progress%)');
            //},
            //onPageStarted: (String url) {
            //  print('Page started loading: $url');
            //},
            //onPageFinished: (String url) {
            //  print('Page finished loading: $url');
            //},
          ),
        ),
      ),
    );
  }
}
