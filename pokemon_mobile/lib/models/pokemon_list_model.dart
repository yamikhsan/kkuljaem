import 'package:pokemon_mobile/models/pokemon_model.dart';

class PokemonListModel {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PokemonListModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonListModel.fromJson(Map<String, dynamic> json) =>
      PokemonListModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Pokemon>.from(
          json["results"].map((x) => Pokemon.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
