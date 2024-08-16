import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_mobile/helpers/storage.dart';
import 'package:pokemon_mobile/models/my_pokemon_model.dart';
import 'package:pokemon_mobile/models/pokemon_detail_model.dart';
import 'package:pokemon_mobile/providers/pokemon_list_provider.dart';
import 'package:pokemon_mobile/services/my_pokemon_service.dart';

final pokemonDetailProvider = AsyncNotifierProvider.autoDispose<
    PokemonDetailNotifier, PokemonDetailModel>(
  PokemonDetailNotifier.new,
);

class PokemonDetailNotifier
    extends AutoDisposeAsyncNotifier<PokemonDetailModel> {
  final storage = GetIt.I<Storage>();
  final myPokemonServices = GetIt.I<MyPokemonService>();

  @override
  FutureOr<PokemonDetailModel> build() {
    return ref.read(pokemonListProvider.notifier).detail;
  }

  Future<bool> catchPokemon() async => await myPokemonServices.catchPokemon();

  Future<void> addPokemon(String? nickname) async {
    final pokemon = state.value!;
    final len = storage.getMyPokemon().length;
    final myPokemon = MyPokemonModel(
      id: len + 1,
      name: pokemon.name!,
      nickname: nickname ?? "",
      image: pokemon.sprites!.frontDefault!,
      countRename: 0,
    );
    final status = await storage.setMyPokemon(myPokemon);
    log("setMyPokemon: $status");
  }
}
