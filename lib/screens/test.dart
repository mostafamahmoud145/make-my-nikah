import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
class testPicker extends StatefulWidget {
  @override
  _testPickerState createState() => _testPickerState();
}

class _testPickerState extends State<testPicker> {
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context,"US");
    setState(() {
      _selectedCountry = country;
    });

  }

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Calling Code Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            country == null
                ? Container()
                : Column(
              children: <Widget>[
                Image.asset(
                  country.flag,
                  package: countryCodePackageName,
                  width: 100,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '${country.callingCode} ${country.name} (${country.countryCode})',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              child: Text('Select Country using full screen'),
              color: Colors.amber,
              onPressed: _onPressed,
            ),
            SizedBox(height: 24,),
            MaterialButton(
              child: Text('Select Country using bottom sheet'),
              color: Colors.orange,
              onPressed: _onPressedShowBottomSheet,
            ),
            SizedBox(height: 24,),
            MaterialButton(
              child: Text('Select Country using dialog'),
              color: Colors.deepOrangeAccent,
              onPressed: _onPressedShowDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    final country =
    await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  void _onPressedShowDialog() async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }
}

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: CountryPickerWidget(
            
            onSelected: (country) => Navigator.pop(context, country),
          ),
        ),
      ),
    );
  }
}