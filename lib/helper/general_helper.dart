import 'package:flutter/cupertino.dart';
import 'package:sadaqah_manager/dto/metal_rates.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeneralHelper {
  static GeneralHelper _generalHelper;
  GeneralHelper._createInstance();

  factory GeneralHelper() {
    if (_generalHelper == null) {
      _generalHelper = GeneralHelper._createInstance();
    }
    return _generalHelper;
  }

  static Future<MetalRates> fetchMetalRates(String currencyCode) async {
    var url =
        Uri.parse('https://data-asg.goldprice.org/dbXRates/$currencyCode');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map responseJson = json.decode(response.body);
      debugPrint('$responseJson');
      return MetalRates.fromJson(responseJson);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load metal rates');
    }
  }
}
