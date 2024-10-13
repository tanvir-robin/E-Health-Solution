import 'package:dental_care/constants.dart';
import 'package:flutter/material.dart';

import 'components/search_form.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Here"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search Your",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Text(
                "Specialist",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: defaultPadding),
              SearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}
