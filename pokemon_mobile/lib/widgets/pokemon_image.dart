import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    super.key,
    required this.url,
    this.radius,
  });

  final String? url;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: CachedNetworkImage(
        imageUrl: url ??
            "https://placehold.co/200?text=!",
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}