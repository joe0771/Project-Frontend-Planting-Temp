import 'dart:convert';

String prettyPrint(dynamic json) {
  try {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  } catch (e) {
    return json;
  }
}
