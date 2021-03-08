import 'package:countries/countries.dart';
import 'package:flutter/material.dart';

class PhoneFormWidget extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController phoneController;
  final ValueChanged<Country> onSelectCountry;
  const PhoneFormWidget({
    Key? key,
    required this.codeController,
    required this.phoneController,
    required this.onSelectCountry,
  }) : super(key: key);

  @override
  _PhoneFormWidgetState createState() => _PhoneFormWidgetState();
}

class _PhoneFormWidgetState extends State<PhoneFormWidget> {
  late Country country;

  @override
  void initState() {
    country = CountriesRepo.getCountryByPhoneCode('1');
    widget.codeController.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //Phone Code
          SizedBox(
            width: 75,
            child: TextFormField(
              controller: widget.codeController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30,
                      child: GestureDetector(
                        onTap: () => showCountriesBottomSheet(
                          context,
                          onValuePicked: (v) => setState(() => country = v),
                        ),
                        child: CountryFlagWidget(country),
                      ),
                    ),
                    SizedBox(width: 4),
                    Align(alignment: Alignment(0, -10), child: Text('+'))
                  ],
                ),
              ),
              onChanged: (str) {
                if (str.length == 3) {
                  FocusScope.of(context).nextFocus();
                }
                country = CountriesRepo.getCountryByPhoneCode(str);
              },
            ),
          ),

          SizedBox(width: 12),
          //Phone Number Main TextField
          Flexible(
            flex: 4,
            child: TextFormField(
              controller: widget.phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                labelText: 'Phone Number',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
