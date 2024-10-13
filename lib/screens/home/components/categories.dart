import 'package:dental_care/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SectionTitle(
            title: "Categories",
            pressOnSeeAll: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              demo_categories.length,
              (index) => CategoryCard(
                category: demo_categories[index],
                press: () {},
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
    required this.press,
  }) : super(key: key);

  final Category category;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: defaultPadding),
      child: InkWell(
        onTap: press,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(defaultPadding / 2),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(category.icon),
              SizedBox(height: defaultPadding / 2),
              Text(
                category.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
