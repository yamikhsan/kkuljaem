import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_mobile/models/pokemon_detail_model.dart';
import 'package:pokemon_mobile/models/pokemon_pagination.dart';
import 'package:pokemon_mobile/services/pokemon_service.dart';

final pokemonListProvider = AsyncNotifierProvider.autoDispose<
    PokemonListNotifier, PagingController<int, PokemonDetailModel>>(
  PokemonListNotifier.new,
);

class PokemonListNotifier extends AutoDisposeAsyncNotifier<
    PagingController<int, PokemonDetailModel>> {
  final service = GetIt.I<PokemonService>();
  final PagingController<int, PokemonDetailModel> pagingController =
      PagingController(firstPageKey: 1);
  String? uri;
  late PokemonDetailModel detail;

  @override
  FutureOr<PagingController<int, PokemonDetailModel>> build() {
    pagingController.addPageRequestListener((page) {
      fetchPokemon(page);
    });
    return pagingController;
  }

  Future<void> fetchPokemon(int page) async {
    log("page: $page");
    if (uri != null || page == 1) {
      PokemonPagination? pagination = await service.fetchPokemon(uri);
      if (pagination != null) {
        uri = pagination.next;
        state.value?.appendPage(pagination.pokemonList, page + 1);
      }
    }
  }

  void goDetail(PokemonDetailModel pokemonDetail) {
    detail = pokemonDetail;
  }
}
