class AvailableDoctor {
  final int id;
  final String name;
  final String sector;
  final int experience;
  final String patients;
  final String image;
  final String email;
  final String password;

  AvailableDoctor({
    required this.id,
    required this.name,
    required this.sector,
    required this.experience,
    required this.patients,
    required this.image,
    required this.email,
    required this.password,
  });
}

List<AvailableDoctor> demoAvailableDoctors = [
  AvailableDoctor(
    id: 1,
    name: "Dr. Sumaiya Rahamn",
    sector: "Medicine Specialist",
    experience: 8,
    patients: '1.08K',
    image: "assets/images/Serena_Gome.png",
    email: "doc1@gmail.com",
    password: "password1",
  ),
  AvailableDoctor(
    id: 2,
    name: "Dr. Asma Khan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Asma_Khan.png",
    email: "doc2@gmail.com",
    password: "password2",
  ),
  AvailableDoctor(
    id: 3,
    name: "Dr. Kiran Shakia",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Kiran_Shakia.png",
    email: "doc3@gmail.comm",
    password: "password3",
  ),
  AvailableDoctor(
    id: 4,
    name: "Dr. Masuda Khan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Masuda_Khan.png",
    email: "doc4@gmail.comm",
    password: "password4",
  ),
  AvailableDoctor(
    id: 5,
    name: "Dr. Johir Raihan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Johir_Raihan.png",
    email: "doc5@gmail.com",
    password: "password5",
  ),
];
