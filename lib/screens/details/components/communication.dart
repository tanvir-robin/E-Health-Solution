import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Communication extends StatelessWidget {
  const Communication({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Color(0xFF51BEFB).withOpacity(0.75),
            ),
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/Call.svg"),
            label: Text("Voice Call"),
          ),
        ),
        SizedBox(width: defaultPadding / 2),
        Expanded(
          child: ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Color(0xFF7E51FB).withOpacity(0.75),
            ),
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/Video.svg",
              width: 11,
            ),
            label: Text("Video Call"),
          ),
        ),
        SizedBox(width: defaultPadding / 2),
        Expanded(
          child: ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Color(0xFFFBA351).withOpacity(0.75),
            ),
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/Chat.svg",
              color: Colors.white,
              width: 11,
            ),
            label: Text("Message"),
          ),
        ),
      ],
    );
  }
}
