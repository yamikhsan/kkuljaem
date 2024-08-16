import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_mobile/helpers/string_extension.dart';
import 'package:pokemon_mobile/models/pokemon_detail_model.dart';
import 'package:pokemon_mobile/providers/pokemon_list_provider.dart';
import 'package:pokemon_mobile/widgets/pokemon_image.dart';

class PokemonListPage extends ConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonListProvider);
    return Scaffold(
      body: pokemon.when(
          data: (provider) {
            return PagedListView<int, PokemonDetailModel>(
              pagingController: provider,
              builderDelegate: PagedChildBuilderDelegate<PokemonDetailModel>(
                itemBuilder: (context, item, index) => PokemonItem(
                  item: item,
                  ref: ref,
                ),
              ),
            );
          },
          error: (e, st) => Center(child: Text("$e")),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}

class PokemonItem extends StatelessWidget {
  const PokemonItem({super.key, required this.item, required this.ref});

  final PokemonDetailModel item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PokemonImage(url: item.sprites?.frontDefault,),
      title: Text("${item.name?.capitalize()}"),
      trailing: const Icon(Icons.chevron_right),
      tileColor: Colors.white,
      onTap: () {
        ref.read(pokemonListProvider.notifier).goDetail(item);
        context.push("/detail", extra: item);
      },
    );
  }
}
