import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/typedefs.dart';
import '../data/countries.dart';
import '../models/country.dart';
import 'flag.dart';

///Provides a customizable [DropdownButton] for all countries
class CountryPickerDropdown extends StatefulWidget {
  /// Filters the available country list
  final ItemFilter? itemFilter;

  /// [Comparator] to be used in sort of country list
  final Comparator<Country>? sortComparator;

  /// List of countries that are placed on top
  final List<Country> priorityList;

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final Widget Function(Country)? itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String? initialValue;

  ///This function will be called whenever a Country item is selected.
  final ValueChanged<Country>? onValuePicked;

  /// Boolean property to enabled/disable expanded property of DropdownButton
  final bool isExpanded;

  /// See [itemHeight] of [DropdownButton]
  final double itemHeight;

  /// See [isDense] of [DropdownButton]
  final bool isDense;

  /// See [underline] of [DropdownButton]
  final Widget? underline;

  /// Selected country widget builder to display. See [selectedItemBuilder] of [DropdownButton]
  final ItemBuilder? selectedItemBuilder;

  /// See [dropdownColor] of [DropdownButton]
  final Color? dropdownColor;

  /// See [onTap] of [DropdownButton]
  final VoidCallback? onTap;

  /// See [icon] of [DropdownButton]
  final Widget? icon;

  /// See [iconDisabledColor] of [DropdownButton]
  final Color? iconDisabledColor;

  /// See [iconEnabledColor] of [DropdownButton]
  final Color? iconEnabledColor;

  /// See [iconSize] of [DropdownButton]
  final double iconSize;

  /// See [hint] of [DropdownButton]
  final Widget? hint;

  /// See [disabledHint] of [DropdownButton]
  final Widget? disabledHint;

  const CountryPickerDropdown({
    Key? key,
    this.itemFilter,
    this.sortComparator,
    this.priorityList = const [],
    this.itemBuilder,
    this.initialValue,
    this.onValuePicked,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.isDense = false,
    this.underline,
    this.selectedItemBuilder,
    this.dropdownColor,
    this.onTap,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.hint,
    this.disabledHint,
  }) : super(key: key);

  @override
  _CountryPickerDropdownState createState() => _CountryPickerDropdownState();
}

class _CountryPickerDropdownState extends State<CountryPickerDropdown> {
  late List<Country> _countries;
  late Country _selectedCountry;

  @override
  void initState() {
    _countries = [
      for (final c in CountriesRepo.countryList)
        if (widget.itemFilter?.call(c) ?? true) c
    ];

    if (widget.sortComparator != null) {
      _countries.sort(widget.sortComparator);
    }

    if (widget.priorityList.isNotEmpty) {
      for (final country in widget.priorityList) {
        _countries.removeWhere((c) => country.isoCode == c.isoCode);
      }
      _countries.insertAll(0, widget.priorityList);
    }

    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries.firstWhere(
          (c) => c.isoCode == widget.initialValue?.toUpperCase(),
        );
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else if (_countries.isNotEmpty) {
      _selectedCountry = _countries[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Country>(
      hint: widget.hint,
      disabledHint: widget.disabledHint,
      onTap: widget.onTap,
      icon: widget.icon,
      iconSize: widget.iconSize,
      iconDisabledColor: widget.iconDisabledColor,
      iconEnabledColor: widget.iconEnabledColor,
      dropdownColor: widget.dropdownColor,
      underline: widget.underline ?? SizedBox(),
      isDense: widget.isDense,
      isExpanded: widget.isExpanded,
      onChanged: (value) {
        if (value == null) return;
        _selectedCountry = value;
        widget.onValuePicked?.call(value);
        setState(() {});
      },
      items: [
        for (final c in _countries)
          DropdownMenuItem<Country>(
            value: c,
            child: widget.itemBuilder?.call(c) ??
                Row(
                  children: <Widget>[
                    CountryFlagWidget(c),
                    SizedBox(width: 8.0),
                    Text("(${c.isoCode}) +${c.phoneCode}"),
                  ],
                ),
          ),
      ],
      value: _selectedCountry,
      itemHeight: widget.itemHeight,
      selectedItemBuilder: widget.selectedItemBuilder != null
          ? (_) => [
                for (final c in _countries) widget.selectedItemBuilder!(c),
              ]
          : null,
    );
  }
}
