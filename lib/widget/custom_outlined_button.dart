import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/widget/resopnsive.dart';


class CustomOulinedButton extends StatelessWidget {
  const CustomOulinedButton({
    super.key,
    this.color,
    this.borderColor,
    this.iconData,
    this.image,
    this.size,
    required this.onPress,
    this.loading = false,
  });

  final Color? color;

  final Color? borderColor;

  final IconData? iconData;

  final String? image;

  final double? size;

  final Function() onPress;

  final bool loading;

  static Border outlineBorder([Color? borderColor]) =>
      Border.all(color: borderColor ?? AppColors.lightGrey, width: .5.w);

  @override
  Widget build(BuildContext context) {
    Size _size=MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        image == null? Navigator.pop(context): onPress;
      },
      child: Container(

        height: (kIsWeb||_size.width >= 500)
            ?75.r:45.r,
        width: (kIsWeb||_size.width >= 500)
            ?75.r:45.r,
        decoration: decoration(_size),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            size: (kIsWeb && _size.width >400)?75.r:45.r,
            color:AppColors.black2,
          ),
        ),
      ),
    );

      Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: outlineBorder(borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: loading ? null : onPress,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: loading
              ? SizedBox(
                  width: size ?? 25,
                  height: size ?? 25,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : iconData != null
                  ? Icon(
                      iconData,
                      size: 25,
                      color: color ?? Theme.of(context).primaryColor,
                    )
                  : Image.asset(
                      image!,
                      width: size,
                      height: size,
                    ),
        ),
      ),
    );
  }
  BoxDecoration decoration(Size size) {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular((kIsWeb||size.width >= 500)
?15:8.0),
      border: CustomOulinedButton.outlineBorder(),
      // boxShadow: [
      //   BoxShadow(
      //     color: Color.fromRGBO(123, 108, 150, 0.18),
      //     blurRadius: 8.0,
      //     spreadRadius: 0.0,
      //     offset: Offset(0.0, 1.0),
      //   )
      // ],
    );
  }
}
