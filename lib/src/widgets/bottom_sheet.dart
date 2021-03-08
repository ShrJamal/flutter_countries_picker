import 'package:flutter/material.dart';

import '../../countries.dart';
import '../core/typedefs.dart';
import 'country_item.dart';

void showCountriesBottomSheet(
  BuildContext context, {
  required ValueChanged<Country> onValuePicked,
  ItemBuilder? itemBuilder,
  ItemFilter? itemFilter,
  Comparator<Country>? sortComparator,
  List<Country> priorityList = const [],
  SearchWidgetStyle? searchWidgetStyle,
  Widget? searchEmptyView,
  bool popOnPick = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CountryBottomSheet(
      onValuePicked: onValuePicked,
      itemBuilder: itemBuilder,
      sortComparator: sortComparator,
      priorityList: priorityList,
      searchWidgetStyle: searchWidgetStyle,
      searchEmptyView: searchEmptyView,
      popOnPick: popOnPick,
    ),
  );
}

class CountryBottomSheet extends StatefulWidget {
  /// Callback that is called with selected Country
  final ValueChanged<Country> onValuePicked;

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

  const CountryBottomSheet({
    Key? key,
    required this.onValuePicked,
    this.itemFilter,
    this.sortComparator,
    this.priorityList = const [],
    this.itemBuilder,
    this.popOnPick = true,
    this.searchWidgetStyle,
    this.searchEmptyView,
  }) : super(key: key);

  @override
  SingleChoiceDialogState createState() {
    return SingleChoiceDialogState();
  }
}

class SingleChoiceDialogState extends State<CountryBottomSheet> {
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
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height / 3 * 2,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withAlpha(240),
      ),
      child: Column(
        children: [
          CountriesSearchWidget(
            allCountries: _allCountries,
            onChange: (v) => setState(() => _filteredCountries = v),
            style: widget.searchWidgetStyle,
          ),
          SizedBox(height: 10),
          if (_filteredCountries.isEmpty)
            widget.searchEmptyView ?? Center(child: Text('No country found.'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: widget.itemBuilder?.call(_filteredCountries[i]) ??
                      CountryItemWidget(
                        _filteredCountries[i],
                        onTap: (v) {
                          widget.onValuePicked(v);
                          if (widget.popOnPick) Navigator.pop(context);
                        },
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
