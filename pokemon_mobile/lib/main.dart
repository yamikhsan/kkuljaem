import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_mobile/helpers/storage.dart';
import 'package:pokemon_mobile/routes.dart';
import 'package:pokemon_mobile/services/my_pokemon_service.dart';
import 'package:pokemon_mobile/services/pokemon_service.dart';

void setupGetIt() {
  GetIt.I.registerSingleton<PokemonService>(PokemonService());
  GetIt.I.registerSingleton<MyPokemonService>(MyPokemonService());
  GetIt.I.registerSingleton<Storage>(Storage());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  await GetIt.I<Storage>().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pokemon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: routes,
    );
  }
}
