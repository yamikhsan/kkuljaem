import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_mobile/helpers/storage.dart';
import 'package:pokemon_mobile/models/my_pokemon_model.dart';
import 'package:pokemon_mobile/services/my_pokemon_service.dart';

final myPokemonProvider =
    AsyncNotifierProvider.autoDispose<MyPokemonNotifier, List<MyPokemonModel>>(
  MyPokemonNotifier.new,
);

class MyPokemonNotifier extends AutoDisposeAsyncNotifier<List<MyPokemonModel>> {
  final storage = GetIt.I<Storage>();
  final myPokemonService = GetIt.I<MyPokemonService>();

  @override
  FutureOr<List<MyPokemonModel>> build() {
    return storage.getMyPokemon();
  }

  Future<bool> release(int id) async {
    final release = await myPokemonService.releasePokemon();
    if (release) {
      final status = await storage.deleteMyPokemon(id);
      log("release: $status");
      if (status) state = AsyncData(storage.getMyPokemon());
    }
    return release;
  }

  Future<void> rename(MyPokemonModel pokemon) async {
    final res = await myPokemonService.renamePokemon(
      name: "${pokemon.name} ${pokemon.nickname}",
      count: "${pokemon.countRename}",
    );
    if (res.isNotEmpty) {
      final newPokemon = MyPokemonModel(
        id: pokemon.id,
        name: pokemon.name,
        nickname: pokemon.nickname,
        image: pokemon.image,
        countRename: res["count"],
        rename: res["rename"],
      );
      final status = await storage.updateMyPokemon(newPokemon);
      if (status) state = AsyncData(storage.getMyPokemon());
    }
  }
}
