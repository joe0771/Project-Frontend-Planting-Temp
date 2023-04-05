import 'dart:convert';

List<ResponseRequestLineModel> responseRequestLineModelFromJson(String str) => List<ResponseRequestLineModel>.from(json.decode(str).map((x) => ResponseRequestLineModel.fromJson(x)));
String responseRequestLineModelToJson(List<ResponseRequestLineModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseRequestLineModel {
  ResponseRequestLineModel({
    required this.drying,
    required this.curing,
    required this.lineId,
  });

  final Ing drying;
  final Ing curing;
  final String lineId;

  factory ResponseRequestLineModel.fromJson(Map<String, dynamic> json) => ResponseRequestLineModel(
    drying: Ing.fromJson(json["drying"]),
    curing: Ing.fromJson(json["curing"]),
    lineId: json["lineId"],
  );

  Map<String, dynamic> toJson() => {
    "drying": drying.toJson(),
    "curing": curing.toJson(),
    "lineId": lineId,
  };
}

class Ing {
  Ing({
    required this.status,
    required this.pv,
    required this.sv,
    required this.min,
    required this.max,
    required this.updateAt,
  });

  final String status;
  final dynamic pv;
  final dynamic sv;
  final int min;
  final int max;
  final String? updateAt;

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
    status: json["status"],
    pv: json["pv"],
    sv: json["sv"],
    min: json["min"],
    max: json["max"],
    updateAt: json["updateAt"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "pv": pv,
    "sv": sv,
    "min": min,
    "max": max,
    "updateAt": updateAt,
  };
}
