// To parse this JSON data, do
//
//     final Commands = CommandsFromJson(jsonString);

import 'dart:convert';

Commands commandsFromJson(String str) => Commands.fromJson(json.decode(str));

String CommandsToJson(Commands data) => json.encode(data.toJson());

class Commands {
  Commands({
    required this.errcode,
    required this.message,
    required this.result,
  });

  int errcode;
  String message;
  List<dynamic> result;

  factory Commands.fromJson(Map<String, dynamic> json) => Commands(
        errcode: json["errcode"],
        message: json["message"],
        result: List<dynamic>.from(json["result"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "errcode": errcode,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x)),
      };
}
