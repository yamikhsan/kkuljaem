import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pokemon_mobile/models/pokemon_detail_model.dart';
import 'package:pokemon_mobile/models/pokemon_list_model.dart';
import 'package:pokemon_mobile/models/pokemon_pagination.dart';

class PokemonService {
  String firstUri = 'https://pokeapi.co/api/v2/pokemon';

  Future<PokemonPagination?> fetchPokemon(String? uri) async {
    uri ??= firstUri;
    log("next: $uri");
    try {
      List<PokemonDetailModel> results = [];
      final url = Uri.parse(uri);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final pokemonList = PokemonListModel.fromJson(body);
        for (final result in pokemonList.results) {
          final pokemon = await fetchPokemonDetail(result.url);
          if (pokemon != null) results.add(pokemon);
        }
        final pokemonPagination = PokemonPagination(
          next: pokemonList.next,
          pokemonList: results,
        );
        return pokemonPagination;
      }
    } catch (e) {
      log("error fetch pokemon: $e");
    }
    return null;
  }

  Future<PokemonDetailModel?> fetchPokemonDetail(String uri) async {
    try {
      final url = Uri.parse(uri);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return PokemonDetailModel.fromJson(body);
      }
    } catch (e) {
      log("error fetch detail: $e");
    }
    return null;
  }
}
