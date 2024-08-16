import 'dart:convert';

import 'package:pokemon_mobile/models/my_pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late SharedPreferences _prefs;

  final String myPokemonKey = "MYPOKEMON";

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setMyPokemon(MyPokemonModel pokemon) async {
    String pokemonString = json.encode(pokemon.toJson());
    List<String>? pokemonList = _prefs.getStringList(myPokemonKey);
    pokemonList ??= [];
    pokemonList.add(pokemonString);
    return await _prefs.setStringList(myPokemonKey, pokemonList);
  }

  List<MyPokemonModel> getMyPokemon() {
    List<MyPokemonModel> myPokemonList = [];
    final pokemonStringList = _prefs.getStringList(myPokemonKey);
    if (pokemonStringList != null) {
      for (final pokemonString in pokemonStringList) {
        final pokemonJson = json.decode(pokemonString) as Map<String, dynamic>;
        final pokemon = MyPokemonModel.fromJson(pokemonJson);
        myPokemonList.add(pokemon);
      }
    }
    return myPokemonList;
  }

  Future<bool> deleteMyPokemon(int id) async {
    List<MyPokemonModel> pokemonList = getMyPokemon();
    if (pokemonList.isNotEmpty) {
      pokemonList = pokemonList.where((x) => x.id != id).toList();
      final pokemonStringList = List<String>.from(
        pokemonList.map(
          (x) => json.encode(x.toJson()),
        ),
      );
      return await _prefs.setStringList(myPokemonKey, pokemonStringList);
    }
    return false;
  }

  Future<bool> updateMyPokemon(MyPokemonModel pokemon) async {
    final status = await deleteMyPokemon(pokemon.id);
    if(status) return await setMyPokemon(pokemon);
    return false;
  }
}
