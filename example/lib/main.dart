import 'package:countries/countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'phone_form.dart';

void main() => runApp(
      MaterialApp(
        title: 'Countries Demo',
        home: DemoPage(),
      ),
    );

class DemoPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DemoPage> {
  var _country = CountriesRepo.getCountryByPhoneCode('90');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text('Phone Form'),
          PhoneFormWidget(
            codeController: TextEditingController(text: '1'),
            phoneController: TextEditingController(),
            onSelectCountry: (v) => setState(() => _country = v),
          ),
          SizedBox(height: 30),
          Text('Bottom Sheet'),
          GestureDetector(
            onTap: () => showCountriesBottomSheet(
              context,
              onValuePicked: (v) => setState(() => _country = v),
            ),
            child: CountryFlagWidget(
              _country,
              width: 20,
            ),
          ),
          SizedBox(height: 30),
          Text('Dropdown'),
          CountryPickerDropdown(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            isDense: false,
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
          ),
          SizedBox(height: 30),
          Text("Dialog"),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                  child: CountryPickerDialog(
                    searchWidgetStyle: SearchWidgetStyle(
                      searchCursorColor: Colors.pinkAccent,
                      searchInputDecoration:
                          InputDecoration(hintText: 'Search...'),
                    ),
                    onValuePicked: (Country country) =>
                        setState(() => _country = country),
                    priorityList: [
                      CountriesRepo.getCountryByIsoCode('TR'),
                      CountriesRepo.getCountryByIsoCode('US'),
                    ],
                  ),
                ),
              );
            },
            title: Row(
              children: <Widget>[
                CountryFlagWidget(_country),
                SizedBox(width: 8.0),
                Text("+${_country.phoneCode}"),
                SizedBox(width: 8.0),
                Flexible(child: Text(_country.name))
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
