class Category {
  final String icon, title;

  const Category({required this.icon, required this.title});
}

const List<Category> demo_categories = [
  Category(icon: "assets/icons/Pediatrician.svg", title: "Pedodontist"),
  Category(icon: "assets/icons/Neurosurgeon.svg", title: "Orthodontist"),
  Category(icon: "assets/icons/Cardiologist.svg", title: "Endodontist"),
  Category(
      icon: "assets/icons/Psychiatrist.svg", title: "Public Health Dentist"),
];
