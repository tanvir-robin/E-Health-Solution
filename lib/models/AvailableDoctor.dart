class AvailableDoctor {
  final int id;
  final String name;
  final String sector;
  final int experience;
  final String patients;
  final String image;
  final String email;
  final String password;
  final String degrees;

  AvailableDoctor({
    required this.id,
    required this.name,
    required this.sector,
    required this.experience,
    required this.patients,
    required this.image,
    required this.email,
    required this.password,
    required this.degrees,
  });
}

List<AvailableDoctor> demoAvailableDoctors = [
  AvailableDoctor(
    id: 1,
    name: "Dr. Md. Imran Hossain",
    sector: "Orthodontist",
    experience: 8,
    patients: '1.08K',
    image: "assets/images/doc1.webp",
    degrees:
        '''BDS (DU), PhD (Dental Surgery) France, MSS (Clinical) DU, MPH (USA),
PGT (Orthodontic), PGT (OMS) BSMMU, Research Fellow & Surgeon (STRC Project, Smile Train, USA),
Advanced Implantology (Thailand), Invisalign (Thailand & India),
Advanced Training in Fixed Orthodontic Braces, Implantology & Laser Dentistry (India)''',
    email: "doc1@gmail.com",
    password: "password1",
  ),
  AvailableDoctor(
    id: 2,
    name: "Prof. Dr. B.A.K Azad",
    sector: "OMS",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc2.jpeg",
    degrees: '''BDS, DDS, MCPS, MDS (London), FICP (America)''',
    email: "doc2@gmail.com",
    password: "password2",
  ),
  AvailableDoctor(
    id: 3,
    name: "Dr. Proshenjit Sarker",
    sector: "OMS, Endodontist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc3.webp",
    degrees:
        '''BDS (Dhaka Dental College), PGT (Oral & Maxillofacial Surgery), PGT (Conservative & Endodontics),
PGT (Prosthodontics), Specialized Training on Dental Implant (DGME),
Specialized Training on Aesthetic Dentistry (DGHS), Training On Cross Infection (DGHS)''',
    email: "doc3@gmail.comm",
    password: "password3",
  ),
  AvailableDoctor(
    id: 4,
    name: "Dr. Roksana Begum",
    sector: "Pedodontist, DPH",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc4.png",
    degrees: '''BDS (DDC), PGT (MOHKSA)''',
    email: "doc4@gmail.comm",
    password: "password4",
  ),
  AvailableDoctor(
    id: 5,
    name: "Dr. Farzana Anar",
    sector: "Periodontist, Orthodontist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc5.jpg",
    degrees: '''BDS, FCPS, Conservative Dentistry & Endodontics Specialist''',
    email: "doc5@gmail.com",
    password: "password5",
  ),
];
