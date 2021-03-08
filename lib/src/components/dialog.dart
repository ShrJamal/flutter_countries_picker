import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/typedefs.dart';
import '../data/countries.dart';
import '../models/country.dart';
import 'widgets/country_item.dart';
import 'widgets/search.dart';

///Provides a customizable [Dialog] which displays all countries
/// with optional search feature

class CountryPickerDialog extends StatefulWidget {
  /// Callback that is called with selected Country
  final ValueChanged<Country> onValuePicked;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the dialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be infered from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.alertDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String semanticLabel;

  /// Filters the available country list
  final ItemFilter? itemFilter;

  /// [Comparator] to be used in sort of country list
  final Comparator<Country>? sortComparator;

  /// List of countries that are placed on top
  final List<Country> priorityList;

  ///Callback that is called with selected item of type Country which returns a
  ///Widget to build list view item inside dialog
  final ItemBuilder? itemBuilder;

  final SearchWidgetStyle? searchWidgetStyle;

  ///The search empty view is displayed if nothing returns from search result
  final Widget? searchEmptyView;

  ///By default the dialog will be popped of the navigator on selection of a value.
  ///Set popOnPick to false to prevent this behaviour.
  final bool popOnPick;

  const CountryPickerDialog({
    Key? key,
    required this.onValuePicked,
    this.semanticLabel = '',
    this.itemFilter,
    this.sortComparator,
    this.priorityList = const [],
    this.itemBuilder,
    this.popOnPick = true,
    this.searchWidgetStyle,
    this.searchEmptyView,
  }) : super(key: key);

  @override
  _CountryPickerDialog createState() {
    return _CountryPickerDialog();
  }
}

class _CountryPickerDialog extends State<CountryPickerDialog> {
  late List<Country> _allCountries;

  late List<Country> _filteredCountries;

  @override
  void initState() {
    _allCountries = [
      for (final v in CountriesRepo.countryList)
        if (widget.itemFilter?.call(v) ?? true) v
    ];

    if (widget.sortComparator != null) {
      _allCountries.sort(widget.sortComparator);
    }

    if (widget.priorityList.isNotEmpty) {
      for (final country in widget.priorityList) {
        _allCountries.removeWhere((c) => country.isoCode == c.isoCode);
      }
      _allCountries.insertAll(0, widget.priorityList);
    }

    _filteredCountries = _allCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: CountriesSearchWidget(
        allCountries: _allCountries,
        onChange: (v) => setState(() => _filteredCountries = v),
        style: widget.searchWidgetStyle,
      ),
      semanticLabel: widget.semanticLabel,
      children: [
        if (_filteredCountries.isNotEmpty)
          Column(
            children: [
              for (final c in _filteredCountries)
                SimpleDialogOption(
                  onPressed: () {
                    widget.onValuePicked(c);
                    if (widget.popOnPick) Navigator.pop(context);
                  },
                  child: widget.itemBuilder?.call(c) ??
                      CountryItemWidget(
                        c,
                        onTap: widget.onValuePicked,
                      ),
                )
            ],
          )
        else
          widget.searchEmptyView ?? Center(child: Text('No country found.')),
      ],
    );
  }
}
