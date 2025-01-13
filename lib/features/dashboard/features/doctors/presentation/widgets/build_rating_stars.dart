import 'package:flutter/material.dart';

List<Widget> buildRatingStars(double rating, ColorScheme theme) {
  List<Widget> stars = [];
  int fullStars = rating.floor(); // Full stars
  bool hasHalfStar = rating - fullStars >= 0.5; // Check for half star

  // Add full stars
  for (int i = 0; i < fullStars; i++) {
    stars.add(Icon(Icons.star, color: theme.primary, size: 20));
  }

  // Add half star if applicable
  if (hasHalfStar) {
    stars.add(Icon(Icons.star_half, color: theme.primary, size: 20));
  }

  // Add empty stars to complete 5 stars display
  for (int i = stars.length; i < 5; i++) {
    stars.add(Icon(Icons.star_border,
        color: theme.onSurface.withOpacity(0.5), size: 20));
  }

  return stars;
}
