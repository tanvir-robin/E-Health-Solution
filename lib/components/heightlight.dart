import 'package:flutter/material.dart';

class Highlight extends StatelessWidget {
  const Highlight({
    super.key,
    required this.name,
    required this.text,
  });

  final String name, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
