import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class InternetChecker {
  Future<bool> hasInternetCheck() async {
    try {
      if (kIsWeb) {
        final result = await get(Uri.parse('google.com'));
        return result.statusCode == 200;
      } else {
        final list = await InternetAddress.lookup('google.com');
        return list.isNotEmpty && list.first.rawAddress.isNotEmpty;
      }
    } catch (e) {
      return false;
    }
  }
}
