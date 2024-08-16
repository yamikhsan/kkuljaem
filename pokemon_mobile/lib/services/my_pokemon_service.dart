import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class MyPokemonService {
  final String _baseUrl =
      Platform.isAndroid ? "10.0.2.2:3000" : "localhost:3000";
  final String _catch = "/catch_pokemon";
  final String _release = "/release_pokemon";
  final String _rename = "/rename_pokemon";

  Future<bool> catchPokemon() async {
    final url = Uri.http(_baseUrl, _catch);
    log("url: $url");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return body["catch"];
    }
    return false;
  }

  Future<bool> releasePokemon() async {
    final url = Uri.http(_baseUrl, _release);
    log("url: $url");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      log("release: ${response.body}");
      final body = json.decode(response.body) as Map<String, dynamic>;
      return body["isPrime"];
    }
    return false;
  }

  Future<Map<String, dynamic>> renamePokemon({
    required String name,
    required String count,
  }) async {
    final queryPrams = {
      "name": name,
      "count": count,
    };
    final url = Uri.http(_baseUrl, _rename, queryPrams);
    log("url: $url");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return body;
    }
    return {};
  }
}
