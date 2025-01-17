class ReviewModel {
  final double rating;
  final String message;
  final String doctorId;
  final String appointmentId;

  ReviewModel({
    required this.rating,
    required this.message,
    required this.doctorId,
    required this.appointmentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'message': message,
      'doctorId': doctorId,
      'appointmentId': appointmentId,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      rating: map['rating'],
      message: map['message'],
      doctorId: map['doctorId'],
      appointmentId: map['appointmentId'],
    );
  }
}
