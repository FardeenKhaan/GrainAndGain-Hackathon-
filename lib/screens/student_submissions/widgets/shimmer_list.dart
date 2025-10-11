import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FkShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double borderRadius;

  const FkShimmerList({super.key, this.itemCount = 3, this.itemHeight = 70, this.borderRadius = 12});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: itemHeight,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
      ),
    );
  }
}
