import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.score,
  });
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        score,
        (index) => Padding(
          padding: const EdgeInsets.only(right: defaultPadding / 4),
          child: SvgPicture.asset("assets/icons/star.svg"),
        ),
      ),
    );
  }
}
