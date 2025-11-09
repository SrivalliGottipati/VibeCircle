// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/text_styles.dart';
//
// class ExperienceCard extends StatelessWidget {
//   const ExperienceCard({
//     super.key,
//     required this.title,
//     required this.imageUrl,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final String title;
//   final String imageUrl;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: ColorFiltered(
//             colorFilter: ColorFilter.matrix(selected ? _identity : _greyscale),
//             child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// const List<double> _greyscale = [
//   0.2126, 0.7152, 0.0722, 0, 0,
//   0.2126, 0.7152, 0.0722, 0, 0,
//   0.2126, 0.7152, 0.0722, 0, 0,
//   0, 0, 0, 1, 0,
// ];
//
// const List<double> _identity = [
//   1, 0, 0, 0, 0,
//   0, 1, 0, 0, 0,
//   0, 0, 1, 0, 0,
//   0, 0, 0, 1, 0,
// ];


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import 'dart:math' show pi;

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
    this.index = 0,
  });

  final String title;
  final String imageUrl;
  final bool selected;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Small alternating tilt effect like Figma reference
    final tilt = (index % 2 == 0 ? -4 : 4) * (pi / 180);

    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: tilt,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColorFiltered(
              colorFilter:
              ColorFilter.matrix(selected ? _identity : _greyscale),
              child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

const List<double> _greyscale = [
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

const List<double> _identity = [
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0,
];

