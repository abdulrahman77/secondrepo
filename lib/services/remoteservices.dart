import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fofivoice/models/commands.dart';

class RemoteServices {
  Future<Commands?> sendCommands(searchText) async {
    var client = http.Client();
    var uri = Uri.parse("http://172.16.4.23:5000/voice_search");
    var response = await client.post(
      uri,
      body: jsonEncode(<String, String>{
        'text': searchText,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      var json = response.body;
      return commandsFromJson(json);
    }
    return null;
  }
}
