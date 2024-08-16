import 'package:go_router/go_router.dart';
import 'package:pokemon_mobile/screens/my_pokemon_list.dart';
import 'package:pokemon_mobile/screens/pokemon_detail.dart';
import 'package:pokemon_mobile/screens/pokemon_home.dart';
import 'package:pokemon_mobile/screens/pokemon_list.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PokemonHomePage(),
    ),
    GoRoute(
      path: '/list',
      builder: (context, state) => const PokemonListPage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) => const PokemonDetailPage(),
    ),
    GoRoute(
      path: '/my_pokemon',
      builder: (context, state) => const MyPokemonListPage(),
    ),
  ],
);
