import 'package:pokemon_mobile/models/pokemon_detail_model.dart';

class PokemonPagination {
  final String? next;
  final List<PokemonDetailModel> pokemonList;

  PokemonPagination({
    required this.next,
    required this.pokemonList,
  });
}
