import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'config.dart';
import 'package:woocommerce_app/models/customer.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.secret),
    );

    bool ret = false; // return
    try {
      var response = await Dio().post(Config.url + Config.customerURL,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json"
          }));
      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        // duplicate user id or email
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }
}
