import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
