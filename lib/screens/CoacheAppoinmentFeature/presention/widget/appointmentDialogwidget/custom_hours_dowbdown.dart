import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/colorsFile.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'available_hours_widget.dart';

class DropdownContainer extends StatefulWidget {
  final List<String> options;
  final void Function(String?)? onChanged;

  const DropdownContainer(
      {super.key, required this.options, required this.onChanged});
  @override
  _DropdownContainerState createState() => _DropdownContainerState();
}

class _DropdownContainerState extends State<DropdownContainer> {
  String? _selectedItem;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    print(widget.options);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    show = !show;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: AppPadding.p21_3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedItem == null
                            ? getTranslated(context, 'selectAppointment')
                            : calculateFinalTime(_selectedItem!),
                        style: TextStyle(
                            fontFamily: getTranslated(context, 'Montserratsemibold'),
                            color: AppColors.pink2,
                            fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: convertPtToPx(20).h,
                      width: convertPtToPx(21).w,
                      child:  !show ? Image.asset(AssetsManager.cursorup) : Image.asset(AssetsManager.cursordown),
                     //   color: AppColors.pink2,
                      ),
                    ],
                  ),
                ),
              ),
              if (show) ...[
                Divider(
                  color: AppColors.lightGrey8,
                ),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItem = widget.options[index];
                        show = !show;
                        widget.onChanged!(widget.options[index]);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p21_3.w, vertical: 16.0),
                      child: Text(
                        calculateFinalTime(widget.options[index]),
                        style: TextStyle(
                          fontFamily: getTranslated(context, 'Montserratsemibold'),
                          color: AppColors.black3,
                          fontSize: convertPtToPx(AppFontsSizeManager.s16).sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  shrinkWrap: true,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
