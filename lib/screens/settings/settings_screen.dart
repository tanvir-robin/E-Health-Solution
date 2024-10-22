import 'package:dental_care/constants.dart';
import 'package:flutter/material.dart';

import 'components/setting_item_caed.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              SettingTab(
                text: "Notifications",
                iconSrc: "assets/icons/Notificatio_box.svg",
                value: true,
                onChanged: (value) {},
              ),
              SettingTab(
                text: "Message Option",
                iconSrc: "assets/icons/Chat_box.svg",
                value: false,
                onChanged: (value) {},
              ),
              SettingTab(
                text: "Video Call Option",
                iconSrc: "assets/icons/Video_box.svg",
                value: false,
                onChanged: (value) {},
              ),
              SettingTab(
                text: "Call Optionn",
                iconSrc: "assets/icons/Call_box.svg",
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
