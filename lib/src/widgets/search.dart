import 'package:flutter/material.dart';

import '../../countries.dart';

class CountriesSearchWidget extends StatelessWidget {
  final List<Country> allCountries;
  final ValueChanged<List<Country>> onChange;
  final SearchWidgetStyle? style;

  const CountriesSearchWidget({
    Key? key,
    required this.allCountries,
    required this.onChange,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: style?.searchCursorColor,
      decoration:
          style?.searchInputDecoration ?? InputDecoration(hintText: 'Search'),
      onChanged: (v) {
        bool searchFilter(Country c) =>
            style?.searchFilter?.call(c, v) ??
            c.name.toLowerCase().startsWith(v.toLowerCase()) ||
                c.phoneCode.startsWith(v.toLowerCase()) ||
                c.isoCode.toLowerCase().startsWith(v.toLowerCase()) ||
                c.iso3Code.toLowerCase().startsWith(v.toLowerCase());
        onChange([
          for (final c in allCountries)
            if (searchFilter(c)) c
        ]);
      },
    );
  }
}

///Predicate to be satisfied in order to add country to search list
typedef SearchFilter = bool Function(Country country, String searchWord);

class SearchWidgetStyle {
  final Color? searchCursorColor;

  final InputDecoration? searchInputDecoration;

  ///Filters the country list for search
  final SearchFilter? searchFilter;

  SearchWidgetStyle({
    this.searchCursorColor,
    this.searchInputDecoration,
    this.searchFilter,
  });
}
