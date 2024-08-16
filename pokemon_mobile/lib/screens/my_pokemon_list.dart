import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_mobile/helpers/string_extension.dart';
import 'package:pokemon_mobile/helpers/toast.dart';
import 'package:pokemon_mobile/models/my_pokemon_model.dart';
import 'package:pokemon_mobile/providers/my_pokemon_provider.dart';
import 'package:pokemon_mobile/widgets/pokemon_image.dart';

enum Action { release, rename }

class MyPokemonListPage extends ConsumerWidget {
  const MyPokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(myPokemonProvider);
    return Scaffold(
      body: pokemon.when(
          data: (provider) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: provider.length,
              reverse: true,
              itemBuilder: (context, index) {
                return PokemonItem(item: provider[index], ref: ref);
              },
            );
          },
          error: (e, st) => Center(child: Text("$e")),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}

class PokemonItem extends StatelessWidget {
  const PokemonItem({super.key, required this.item, required this.ref});

  final MyPokemonModel item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final name = item.rename ?? "${item.name.capitalize()} ${item.nickname}";
    return ListTile(
      leading: PokemonImage(url: item.image),
      title: Text(name),
      tileColor: Colors.white,
      onTap: () {
        showPokemonAction(context, ref);
      },
    );
  }

  void showPokemonAction(BuildContext context, WidgetRef ref) async {
    final pokemonAction = ref.read(myPokemonProvider.notifier);
    final action = await showDialog<Action?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const PokemonActionDialog(),
    );
    if (action != null) {
      if (action == Action.release) {
        Color? color;
        final release = await pokemonAction.release(item.id);
        final message = release
            ? "Successfully Release ${item.name.capitalize()}"
            : "Failed to Release ${item.name.capitalize()}";
        if (release) color = Colors.green;
        showToast(message, color: color);
      }
      if (action == Action.rename) pokemonAction.rename(item);
    }
  }
}

class PokemonActionDialog extends StatelessWidget {
  const PokemonActionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Action",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (Action action in Action.values)
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: () {
                  context.pop(action);
                },
                style: TextButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor:
                      action == Action.release ? Colors.red : Colors.green,
                ),
                child: Text(
                  action.name.capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }
}
