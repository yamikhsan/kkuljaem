import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_mobile/helpers/toast.dart';
import 'package:pokemon_mobile/models/pokemon_detail_model.dart';
import 'package:pokemon_mobile/providers/pokemon_detail_provider.dart';
import 'package:pokemon_mobile/widgets/gap.dart';
import 'package:pokemon_mobile/widgets/pokemon_image.dart';

class PokemonDetailPage extends ConsumerWidget {
  const PokemonDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(pokemonDetailProvider);
    final detailAction = ref.read(pokemonDetailProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text("Pokemon Detail")),
      body: detail.when(
        data: (provider) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              PokemonImage(
                url: provider.sprites?.frontDefault,
                radius: 50,
              ),
              const Gap(),
              TextButton(
                onPressed: () async {
                  final status = await detailAction.catchPokemon();
                  if (status) {
                    if (context.mounted) pokemonNameDialog(context, ref);
                  } else {
                    showToast("Escape");
                  }
                },
                style: TextButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.redAccent,
                ),
                child: Text(
                  "Catch",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
              const Gap(),
              Text(
                "Types",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Wrap(
                children: [
                  for (Type type in provider.types ?? [])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text("${type.type?.name}"),
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    )
                ],
              ),
              const Gap(),
              Text(
                "Moves",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Wrap(
                children: [
                  for (Move move in provider.moves ?? [])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text("${move.move?.name}"),
                        backgroundColor: Colors.amber,
                      ),
                    )
                ],
              ),
            ],
          );
        },
        error: (e, st) => Center(
          child: Text("$e"),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void pokemonNameDialog(BuildContext context, WidgetRef ref) async {
    final nickname = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PokemonNameDialog(),
    );
    final pokemonAction = ref.read(pokemonDetailProvider.notifier);
    await pokemonAction.addPokemon(nickname);
  }
}

class PokemonNameDialog extends StatelessWidget {
  PokemonNameDialog({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Captured",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            textInputAction: TextInputAction.done,
            maxLength: 50,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.all(10.0),
              // filled: true,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.grey[500]),
              hintText: "Give pokemon nickname",
              enabledBorder: decorationInputBorder(),
              focusedBorder: decorationInputBorder(),
            ),
            onSubmitted: (text) {
              context.pop(text);
            },
          ),
          TextButton(
            onPressed: () {
              context.pop(textController.text);
            },
            child: Text(
              "Done",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  OutlineInputBorder decorationInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
