import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:temperature/src/services/api_base.dart';
import 'package:temperature/src/models/return_status_model.dart';
import 'package:temperature/src/models/response_request_line_model.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  static Future<List<ResponseRequestLineModel>?> requestLine() async {
    try {
      Response response = await API_BASE.get('api/client-request-line');
      Map<String, dynamic> data = response.data;
      List json = data["result"];
      List<ResponseRequestLineModel> list = [];
      list = json.map((data) => ResponseRequestLineModel.fromJson(data)).toList();
      return list;
    } on DioError catch (e) {
      log("❌ Error $e ❌");
      return null;
    } on Exception catch (e) {
      log("❌ Error $e ❌");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> requestAverage(String date, String shift) async {
    Map<String, dynamic> body = {
      "date": date,
      "shift": shift,
    };
    try {
      Response response = await API_BASE.post('api/client-request-average', data: body);
      Map<String, dynamic> mapJson = response.data;
      final json = mapJson["result"];
      return json;
    } on DioError catch (e) {
      print(e);
      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> requestReport(String day) async {
    try {
      Response response = await API_BASE.get('api/client-request-report/$day');
      Map<String, dynamic> mapJson = response.data;
      final json = mapJson["result"];
      return json;
    } on DioError catch (e) {
      print(e);
      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ReturnStatusModel?> settingTemp(
    String lineId,
    int minD,
    int maxD,
    int minC,
    int maxC,
  ) async {
    Map<String, dynamic> body = {
      "lineId": lineId,
      "drying": {"min": minD, "max": maxD},
      "curing": {"min": minC, "max": maxC}
    };
    try {
      Response response = await API_BASE.post('api/client-setting-temp', data: body);
      return ReturnStatusModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
