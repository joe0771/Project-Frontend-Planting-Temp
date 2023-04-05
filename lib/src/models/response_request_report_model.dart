// To parse this JSON data, do
//
//     final responseRequestReportModel = responseRequestReportModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ResponseRequestReportModel> responseRequestReportModelFromJson(String str) => List<ResponseRequestReportModel>.from(json.decode(str).map((x) => ResponseRequestReportModel.fromJson(x)));

String responseRequestReportModelToJson(List<ResponseRequestReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseRequestReportModel {
  ResponseRequestReportModel({
    required this.drying,
    required this.curing,
    required this.timeStamp,
  });

  final dynamic drying;
  final dynamic curing;
  final int timeStamp;

  factory ResponseRequestReportModel.fromJson(Map<String, dynamic> json) => ResponseRequestReportModel(
    drying: json["drying"],
    curing: json["curing"],
    timeStamp: json["timeStamp"],
  );

  Map<String, dynamic> toJson() => {
    "drying": drying,
    "curing": curing,
    "timeStamp": timeStamp,
  };
}

