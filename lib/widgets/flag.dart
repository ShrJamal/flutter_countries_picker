import 'package:flutter/material.dart';

import '../data/countries.dart';
import '../models/country.dart';

class CountryFlagWidget extends StatelessWidget {
  final Country country;

  const CountryFlagWidget(
    this.country, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CountriesRepo.getFlagImageAssetPath(country.isoCode),
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
      package: "countries",
    );
  }
}
