import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;
  final bool? isWeb;


  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
    this.isWeb
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: leadingPadding),
          _Flag(
            isWeb: isWeb,
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
          ),
          SizedBox(width: isWeb == true ? 25 : 12.0),
          Text(
            '$dialCode',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final bool? isWeb;


  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji, this.isWeb = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Transform.scale(
                scale: isWeb == true ? 1.4 : 1,
                child: ClipOval(
                  child: Image.asset(
                    country!.flagUri,
                    height: isWeb == true ? 70 : 32,
                    width: isWeb == true ? 70 : 32,
                    fit: BoxFit.fill,
                    package: 'intl_phone_number_input',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
