import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
// import 'package:intl_phone_number_input/src/utils/app_values.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

import '../utils/colorsFile.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Container(
      height: 75.h,
      width: 118.6.w,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey3),
          borderRadius: BorderRadius.circular(10.6.r)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: leadingPadding),
          Container(
            child: _Flag(
              country: country,
              showFlag: showFlag,
              useEmoji: useEmoji,
            ),
          ),
          //SizedBox(width: 12.0),
          /*Text(
            '$dialCode',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),*/
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(country!.flagUri);
    return country != null && showFlag!
        ? Flexible(
          child: Container(
            width: 115.w,
              child: useEmoji!
                  ? Text(
                      Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset(
                            country!.flagUri,
                            height: 45.3.h,
                            width: 45.3.w,
                            fit: BoxFit.fill,
                            package: 'intl_phone_number_input',
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox.shrink();
                              },
                            ),
                        ),
                      ),
                      /*SizedBox(
                        width: 21.3.w,
                      ),*/
                      Image.asset(
                        'assets/images/bottom.png',
                        package: 'intl_phone_number_input',
                      ),
                    ],
                  ),
            ),
        )
        : SizedBox.shrink();
  }
}
