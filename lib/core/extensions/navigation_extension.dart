import 'package:flutter/material.dart';

extension ExtensionNavgter on BuildContext {
  Future<dynamic> pushWidget({required Widget push}) {
    return Navigator.push(this, MaterialPageRoute(builder: (context) => push));
  }

  Future<dynamic> pushReplacement({required Widget pushReplacement}) {
    return Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => pushReplacement));
  }
}

