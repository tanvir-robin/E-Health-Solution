import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SettingTab extends StatelessWidget {
  const SettingTab({
    super.key,
    this.text,
    this.iconSrc,
    required this.value,
    required this.onChanged,
  });

  final String? text, iconSrc;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: const BoxDecoration(color: Colors.white),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        leading: SvgPicture.asset(iconSrc!),
        title: Text(
          text!,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: CupertinoSwitch(
          activeColor: primaryColor,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
