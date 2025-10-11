import 'package:flutter/material.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:shimmer/shimmer.dart';

class FkShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const FkShimmerList({super.key, this.itemCount = 3, this.itemHeight = 70});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: FkSizes.sm),
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(FkSizes.borderRadiusMd * 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
