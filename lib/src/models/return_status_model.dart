import 'dart:convert';

ReturnStatusModel cardModelFromJson(String str) => ReturnStatusModel.fromJson(json.decode(str));

String cardModelToJson(ReturnStatusModel data) => json.encode(data.toJson());

class ReturnStatusModel {
  ReturnStatusModel({
    required this.success,
    required this.message,
  });

  final bool? success;
  final String? message;

  factory ReturnStatusModel.fromJson(Map<String, dynamic> json) => ReturnStatusModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
