import 'dart:convert';

import 'package:InfraVision/ar_services/ar_launcher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ARWebViewScreen extends StatefulWidget {
  final List<String> modelList;

  const ARWebViewScreen({
    super.key,
    required this.modelList,
  });

  @override
  State<ARWebViewScreen> createState() => _ARWebViewScreenState();
}

class _ARWebViewScreenState extends State<ARWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {

            /// 🔥 Send all models to WebView
            final modelsJson = jsonEncode(widget.modelList);

            controller.runJavaScript(
              "setModels($modelsJson);",
            );
          },
        ),
      )

      ..addJavaScriptChannel(
        'FlutterAR',
        onMessageReceived: (message) {

          final modelUrl = message.message;

          /// Launch native AR
          launchAR(modelUrl);
        },
      )

      ..loadFlutterAsset('assets/web/ar_view.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D Preview"),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}