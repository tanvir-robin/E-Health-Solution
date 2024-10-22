import 'package:flutter/material.dart';

import '../constants.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.pressOnSeeAll,
  });

  final String title;
  final VoidCallback pressOnSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // TextButton(
        //   onPressed: pressOnSeeAll,
        //   child: const Text(
        //     "See All",
        //     style: TextStyle(color: textColor),
        //   ),
        // ),
      ],
    );
  }
}
