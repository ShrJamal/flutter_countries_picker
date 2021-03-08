import 'package:flutter/material.dart';

import '../data/countries.dart';
import '../models/country.dart';

class CountryFlagWidget extends StatelessWidget {
  final Country country;
  final double width;
  final double height;

  const CountryFlagWidget(
    this.country, {
    this.width = 30,
    this.height = 30,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CountriesRepo.getFlagImageAssetPath(country.isoCode),
      width: width,
      height: height,
      package: "countries",
    );
  }
}
