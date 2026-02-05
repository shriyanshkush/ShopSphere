import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../common/constants/GlobalVariable.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariable.carouselImages.map((i) {
        return Image.network(
          i,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 1,
        height: 180,
        autoPlayCurve: Curves.easeInOut,
      ),
    );
  }
}
