import 'package:flutter/material.dart';

import '../../../countries.dart';
import 'flag.dart';

class CountryItemWidget extends StatelessWidget {
  final Country country;
  final ValueChanged<Country> onTap;

  const CountryItemWidget(
    this.country, {
    Key? key,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(country),
      child: Row(
        children: [
          CountryFlagWidget(
            country,
            width: 35,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text('+${country.phoneCode}  - ${country.name}'),
          ),
        ],
      ),
    );
  }
}
