import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reprint/flutter_reprint.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fingerprintReaderAvailable = "NO";
  String _authStatus = '';
  bool isErrorMessage = false;

  TextStyle authMessageStyle,
      regularAuthMessageStyle = TextStyle(
        color: Colors.indigoAccent,
      );

  TextStyle errorAuthMessageStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String fingerprintReaderAvailable;

    try {
      fingerprintReaderAvailable =
          (await FlutterReprint.canCheckFingerprint) ? 'YES' : 'NO';
    } on PlatformException {
      fingerprintReaderAvailable = "ERROR";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _fingerprintReaderAvailable = fingerprintReaderAvailable;
    });
  }

  _updateAuthMessage(String message, {bool isError = false}) {
    setState(() {
      _authStatus = message;
      authMessageStyle =
          isError ? errorAuthMessageStyle : regularAuthMessageStyle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_reprint example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                      'Fingerprint reader available: $_fingerprintReaderAvailable\n'),
                ),
                ElevatedButton(
                  child: Text(
                    'Authenticate',
                  ),
                  onPressed: () async {
                    _updateAuthMessage('Waiting for fingerprint');

                    FlutterReprint.authenticateWithBiometrics()
                        .then((authResult) {
                      _updateAuthMessage(
                          authResult.success
                              ? "SUCCESS"
                              : "FAILED: ${authResult.failureReason}",
                          isError: !authResult.success);
                    });
                  },
                ),
                ElevatedButton(
                    child: Text(
                      'Stop authentication',
                    ),
                    onPressed: () {
                      try {
                        FlutterReprint.stopAuthentication().then((cancelOK) {
                          _updateAuthMessage(cancelOK
                              ? "Authentication stopped"
                              : "Authentication was not happening");
                        });
                      } on PlatformException catch (e) {
                        _updateAuthMessage(e.message, isError: true);
                      }
                    }),
                Center(
                  child: Text(
                    _authStatus,
                    style: authMessageStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
