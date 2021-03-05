import 'package:countries/countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Pickers Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => DemoPage(),
      },
    );
  }
}

class DemoPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DemoPage> {
  var _selectedDialogCountry = CountriesRepo.getCountryByPhoneCode('90');

  var _selectedFilteredDialogCountry =
      CountriesRepo.getCountryByPhoneCode('90');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Pickers Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CountryPickerDropdown (SOLO)'),
                _buildCountryPickerDropdownSoloExpanded(),
                //ListTile(title: _buildCountryPickerDropdown(longerText: true)),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CountryPickerDropdown (selectedItemBuilder)'),
                _buildCountryPickerDropdown(hasSelectedItemBuilder: true),
                //ListTile(title: _buildCountryPickerDropdown(longerText: true)),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CountryPickerDropdown (filtered)'),
                ListTile(title: _buildCountryPickerDropdown(filtered: true)),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CountryPickerDropdown (sorted by isoCode)'),
                ListTile(
                    title: _buildCountryPickerDropdown(sortedByIsoCode: true)),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("CountryPickerDropdown (has priorityList['GB,'CN'])"),
                ListTile(
                    title: _buildCountryPickerDropdown(hasPriorityList: true)),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("CountryPickerDialog (has priorityList['TR,'US'])"),
                ListTile(
                  onTap: _openCountryPickerDialog,
                  title: _buildDialogItem(_selectedDialogCountry),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CountryPickerDialog (filtered)'),
                ListTile(
                  onTap: _openFilteredCountryPickerDialog,
                  title: _buildDialogItem(_selectedFilteredDialogCountry),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCountryPickerDropdownSoloExpanded() {
    return CountryPickerDropdown(
      underline: Container(
        height: 2,
        color: Colors.red,
      ),
      //show'em (the text fields) you're in charge now
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      //if you want your dropdown button's selected item UI to be different
      //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
      onValuePicked: (Country country) {
        print("${country.name}");
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            CountryFlagWidget(country),
            SizedBox(width: 8.0),
            Expanded(child: Text(country.name)),
          ],
        );
      },
      isExpanded: true,
      //initialValue: 'TR',
      icon: Icon(Icons.arrow_downward),
    );
  }

  _buildCountryPickerDropdown({
    bool filtered = false,
    bool sortedByIsoCode = false,
    bool hasPriorityList = false,
    bool hasSelectedItemBuilder = false,
  }) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.5;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            /* underline: Container(
              height: 2,
              color: Colors.red,
            ),*/
            //show'em (the text fields) you're in charge now
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            //if you have menu items of varying size, itemHeight being null respects
            //that, IntrinsicHeight under the hood ;).
            //itemHeight being null and isDense being true doesn't play along
            //well together. One is trying to limit size and other is saying
            //limit is the sky, therefore conflicts.
            //false is default but still keep that in mind.
            isDense: false,
            //if you want your dropdown button's selected item UI to be different
            //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
            selectedItemBuilder: hasSelectedItemBuilder == true
                ? (Country country) => _buildDropdownSelectedItemBuilder(
                    country, dropdownSelectedItemWidth)
                : null,
            //initialValue: 'AR',
            itemBuilder: (Country country) => hasSelectedItemBuilder == true
                ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
                : _buildDropdownItem(country, dropdownItemWidth),
            initialValue: 'AR',
            itemFilter: filtered
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            //priorityList is shown at the beginning of list
            priorityList: [
              if (hasPriorityList) ...[
                CountriesRepo.getCountryByIsoCode('GB'),
                CountriesRepo.getCountryByIsoCode('CN'),
              ]
            ],
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              print("${country.name}");
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Phone",
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            keyboardType: TextInputType.number,
          ),
        )
      ],
    );
  }

  Widget _buildDropdownItem(Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Row(
          children: <Widget>[
            CountryFlagWidget(country),
            SizedBox(
              width: 8.0,
            ),
            Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
          ],
        ),
      );

  Widget _buildDropdownItemWithLongText(
          Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CountryFlagWidget(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text("${country.name}")),
            ],
          ),
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(
          Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              CountryFlagWidget(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Text(
                '${country.name}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryFlagWidget(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountriesRepo.getCountryByIsoCode('TR'),
              CountriesRepo.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  void _openFilteredCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedFilteredDialogCountry = country),
            itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
            itemBuilder: _buildDialogItem,
          ),
        ),
      );
}
