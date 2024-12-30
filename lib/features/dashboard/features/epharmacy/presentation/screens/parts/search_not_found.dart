import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/not-found.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}