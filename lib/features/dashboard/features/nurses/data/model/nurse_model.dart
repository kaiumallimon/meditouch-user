class NurseModel {
  final String id;
  final int charge;
  final DateTime createdAt;
  final List<Degree> degrees;
  final String district;
  final DateTime dob;
  final String email;
  final String gender;
  final String image;
  final String name;
  final String phone;
  final String role;

  NurseModel({
    required this.id,
    required this.charge,
    required this.createdAt,
    required this.degrees,
    required this.district,
    required this.dob,
    required this.email,
    required this.gender,
    required this.image,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory NurseModel.fromMap(Map<String, dynamic> data, String documentId) {
    final int charge = data['charge'];
    final DateTime createdAt = DateTime.parse(data['createdAt']);
    final List<Degree> degrees = (data['degrees'] as List<dynamic>?)
            ?.map((degreeMap) => Degree.fromMap(degreeMap))
            .toList() ??
        [];
    final String district = data['district'];
    final DateTime dob = data['dob'].toDate();
    final String email = data['email'];
    final String gender = data['gender'];
    final String image = data['image'];
    final String name = data['name'];
    final String phone = data['phone'];
    final String role = data['role'];

    return NurseModel(
        id: documentId,
        charge: charge,
        createdAt: createdAt,
        degrees: degrees,
        district: district,
        dob: dob,
        email: email,
        gender: gender,
        image: image,
        name: name,
        phone: phone,
        role: role);
  }
}

class Degree {
  final String year;
  final String degree;
  final String institution;

  Degree({required this.year, required this.degree, required this.institution});

  factory Degree.fromMap(Map<String, dynamic> data) {
    final year = data['year'];
    final degree = data['degree'];
    final institution = data['institution'];
    return Degree(year: year, degree: degree, institution: institution);
  }

  Map<String, dynamic> toMap() {
    return {'year': year, 'degree': degree, 'institution': institution};
  }

  @override
  String toString() =>
      'Degree(year: $year, degree: $degree, institution: $institution)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Degree otherDegree = other as Degree;
    return otherDegree.year == year &&
        otherDegree.degree == degree &&
        otherDegree.institution == institution;
  }

  @override
  int get hashCode => year.hashCode ^ degree.hashCode ^ institution.hashCode;
}
