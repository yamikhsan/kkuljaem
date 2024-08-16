import 'package:flutter/material.dart';
import 'package:pokemon_mobile/screens/my_pokemon_list.dart';
import 'package:pokemon_mobile/screens/pokemon_list.dart';
import 'package:pokemon_mobile/widgets/keep_page_alive.dart';

class PokemonHomePage extends StatelessWidget {
  const PokemonHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pokemon"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pokemon List"),
              Tab(text: "My Pokemon List"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            KeepPageAlive(child: PokemonListPage()),
            MyPokemonListPage(),
          ],
        ),
      ),
    );
  }
}
