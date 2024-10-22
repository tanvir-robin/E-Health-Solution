class RecommendedDoctor {
  final String name, speciality, institute, image, degree;

  const RecommendedDoctor({
    required this.name,
    required this.speciality,
    required this.institute,
    required this.image,
    required this.degree,
  });
}

const List<RecommendedDoctor> demo_recommended_doctor = [
  RecommendedDoctor(
    name: "Dr. Farzana Anar",
    speciality: "Periodontist, Orthodontist",
    institute: "SmileNest",
    image: "assets/images/doc5.png",
    degree: '''BDS, FCPS, Conservative Dentistry & Endodontics Specialist''',
  ),
  RecommendedDoctor(
    name: "Dr. Proshenjit Sarker",
    speciality: "OMS, Endodontist",
    institute: "SmileNest",
    image: "assets/images/doc3.png",
    degree:
        '''BDS (Dhaka Dental College), PGT (Oral & Maxillofacial Surgery), PGT (Conservative & Endodontics),
PGT (Prosthodontics), Specialized Training on Dental Implant (DGME),
Specialized Training on Aesthetic Dentistry (DGHS), Training On Cross Infection (DGHS)''',
  ),
  RecommendedDoctor(
    name: "Dr. Md. Imran Hossain",
    speciality: "Orthodontist",
    institute: "SmileNest",
    image: "assets/images/doc1.png",
    degree:
        '''BDS (DU), PhD (Dental Surgery) France, MSS (Clinical) DU, MPH (USA),
PGT (Orthodontic), PGT (OMS) BSMMU, Research Fellow & Surgeon (STRC Project, Smile Train, USA),
Advanced Implantology (Thailand), Invisalign (Thailand & India),
Advanced Training in Fixed Orthodontic Braces, Implantology & Laser Dentistry (India)''',
  ),
  RecommendedDoctor(
    name: "Dr. Roksana Begum",
    speciality: "Pedodontist, DPH",
    institute: "SmileNest",
    image: "assets/images/doc4.png",
    degree: '''BDS (DDC), PGT (MOHKSA)''',
  ),
  RecommendedDoctor(
    name: "Prof. Dr. B.A.K Azad",
    speciality: "OMS",
    institute: "SmileNest",
    image: "assets/images/doc2.png",
    degree: '''BDS, DDS, MCPS, MDS (London), FICP (America)''',
  ),
];
