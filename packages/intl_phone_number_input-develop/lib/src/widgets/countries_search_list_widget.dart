import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final bool? isWeb;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.isWeb,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(
            labelText: 'Search by country name or dial code',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.isWeb == true
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_sharp,
                          color: Color(0xFF7B6C96),
                          size: 36,
                        )),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: widget.isWeb == true ? 36 : 15,
                            fontFamily: "Montserratsemibold"),
                        key: Key(TestHelper.CountrySearchInputKeyValue),
                        decoration: getSearchBoxDecoration(),
                        controller: _searchController,
                        autofocus: widget.autoFocus,
                        onChanged: (value) {
                          final String value = _searchController.text.trim();
                          return setState(
                            () => filteredCountries = Utils.filterCountries(
                              countries: widget.countries,
                              locale: widget.locale,
                              value: value,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                    right: 32.h, left: 32.h, top: 64.h, bottom: 42.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 247, 247, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Montserratsemibold"),
                    key: Key(TestHelper.CountrySearchInputKeyValue),
                    decoration: getSearchBoxDecoration(),
                    controller: _searchController,
                    autofocus: widget.autoFocus,
                    onChanged: (value) {
                      final String value = _searchController.text.trim();
                      return setState(
                        () => filteredCountries = Utils.filterCountries(
                          countries: widget.countries,
                          locale: widget.locale,
                          value: value,
                        ),
                      );
                    },
                  ),
                ),
              ),
        widget.isWeb == true
            ? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isWeb == true
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: widget.isWeb == true
                      ? EdgeInsets.symmetric(horizontal: 30, vertical: 40)
                      : EdgeInsets.zero,
                  child: ListView.separated(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (BuildContext context, int index) {
                      Country country = filteredCountries[index];

                      return DirectionalCountryListTile(
                        country: country,
                        locale: widget.locale,
                        showFlags: widget.showFlags!,
                        useEmoji: widget.useEmoji!,
                        isWeb: widget.isWeb,
                      );
                      // return ListTile(
                      //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                      //   leading: widget.showFlags!
                      //       ? _Flag(country: country, useEmoji: widget.useEmoji)
                      //       : null,
                      //   title: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text(
                      //       '${Utils.getCountryName(country, widget.locale)}',
                      //       textDirection: Directionality.of(context),
                      //       textAlign: TextAlign.start,
                      //     ),
                      //   ),
                      //   subtitle: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text(
                      //       '${country.dialCode ?? ''}',
                      //       textDirection: TextDirection.ltr,
                      //       textAlign: TextAlign.start,
                      //     ),
                      //   ),
                      //   onTap: () => Navigator.of(context).pop(country),
                      // );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return widget.isWeb == true
                          ? SizedBox(
                              height: 40,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 1,
                                  color: Color.fromRGBO(211, 211, 211, 1)),
                            );
                    },
                  ),
                ),
              )
            : Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isWeb == true
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: widget.isWeb == true
                      ? EdgeInsets.symmetric(horizontal: 30, vertical: 40)
                      : EdgeInsets.zero,
                  child: ListView.separated(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (BuildContext context, int index) {
                      Country country = filteredCountries[index];

                      return DirectionalCountryListTile(
                        country: country,
                        locale: widget.locale,
                        showFlags: widget.showFlags!,
                        useEmoji: widget.useEmoji!,
                        isWeb: widget.isWeb,
                      );
                      // return ListTile(
                      //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                      //   leading: widget.showFlags!
                      //       ? _Flag(country: country, useEmoji: widget.useEmoji)
                      //       : null,
                      //   title: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text(
                      //       '${Utils.getCountryName(country, widget.locale)}',
                      //       textDirection: Directionality.of(context),
                      //       textAlign: TextAlign.start,
                      //     ),
                      //   ),
                      //   subtitle: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text(
                      //       '${country.dialCode ?? ''}',
                      //       textDirection: TextDirection.ltr,
                      //       textAlign: TextAlign.start,
                      //     ),
                      //   ),
                      //   onTap: () => Navigator.of(context).pop(country),
                      // );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return widget.isWeb == true
                          ? SizedBox(
                              height: 40,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 1,
                                  color: Color.fromRGBO(211, 211, 211, 1)),
                            );
                    },
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final bool? isWeb;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    this.isWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isWeb == true
        ? ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(vertical: 0.1),
            key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
            leading: (showFlags
                ? _Flag(country: country, useEmoji: useEmoji, isWeb: isWeb)
                : null),
            horizontalTitleGap: 15,
            title: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '(${country.dialCode ?? ''})  ${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: "NotoKufiArabic-Regular", fontSize: 36),
              ),
            ),
            onTap: () => Navigator.of(context).pop(country),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0.w),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: 0.1),
              key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
              leading: (showFlags
                  ? _Flag(country: country, useEmoji: useEmoji, isWeb: isWeb)
                  : null),
              horizontalTitleGap: 0,
              title: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  '${Utils.getCountryName(country, locale)}',
                  textDirection: Directionality.of(context),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: "NotoKufiArabic-SemiBold", fontSize: 15),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    '${country.dialCode ?? ''}',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "Montserratmedium",
                      color: Color.fromRGBO(147, 147, 147, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).pop(country),
            ),
          );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;
  final bool? isWeb;

  const _Flag({Key? key, this.country, this.useEmoji, this.isWeb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? isWeb == true
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Transform.scale(
                              scale: 1.7,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  country!.flagUri,
                                  package: 'intl_phone_number_input',
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(
                              country!.flagUri,
                              package: 'intl_phone_number_input',
                            ),
                          )
                    : SizedBox.shrink())
        : SizedBox.shrink();
  }
}
