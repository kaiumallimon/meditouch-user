import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';
import 'package:quickalert/quickalert.dart';

import '../../data/models/review_model.dart';
import '../../data/repository/review_repository.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.appointment});
  final AppointmentModel appointment;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    // Get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rating',
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rate your experience with ${widget.appointment.doctorDetails['name']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.onSurface.withOpacity(.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: RatingBar.builder(
                        initialRating: _currentRating,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: theme.primary,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Your Rating: ${_currentRating.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        hintText: 'Write a review (optional)',
                        hintStyle: TextStyle(
                          color: theme.onSurface.withOpacity(.6),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: theme.primaryContainer,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          size: const Size(120, 50),
                          text: "Submit",
                          onPressed: () async {
                            // Check if rating is 0
                            if (_currentRating == 0.0) {
                              // Show error message
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: "Error",
                                text: "Please rate the doctor",
                              );
                              return;
                            }

                            // Get review message
                            final String reviewMessage = reviewController.text.trim();

                            // Show loading dialog
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              title: "Please wait",
                              text: "Submitting review",
                            );

                            try {
                              // Create review model
                              final ReviewModel reviewModel = ReviewModel(
                                rating: _currentRating,
                                message: reviewMessage,
                                doctorId: widget.appointment.doctorId,
                                appointmentId: widget.appointment.appointmentId,
                              );

                              // Add review
                              final bool isSuccess = await ReviewRepository().addReview(reviewModel);

                              // Close loading dialog
                              Navigator.of(context).pop();

                              if (isSuccess) {
                                // Show success message
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "Success",
                                  text: "Review submitted successfully",
                                  onConfirmBtnTap: () {
                                    setState(() {
                                      // Clear rating and review
                                      _currentRating = 0.0;
                                      reviewController.clear();
                                    });
                                    // Navigate to dashboard
                                    Navigator.of(context).pop(); // Close success dialog
                                    Navigator.of(context).pushNamed('/dashboard');
                                  },
                                );
                              } else {
                                // Show error message
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: "Error",
                                  text: "Failed to submit review",
                                );
                              }
                            } catch (e) {
                              // Close loading dialog
                              Navigator.of(context).pop();

                              // Show error dialog
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: "Error",
                                text: "An unexpected error occurred. Please try again.",
                              );
                            }
                          },
                          bgColor: theme.primary,
                          fgColor: theme.onPrimary,
                          isLoading: false,
                        )

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController reviewController = TextEditingController();
}
