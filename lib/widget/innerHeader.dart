
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
class InnerHeader extends StatelessWidget {
  final String title;
  final Size size;
  InnerHeader({required this.title, required this.size});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
              width: size.width,
              height: 80,
              color: Colors.white,
              child: SafeArea(
                  child: Padding( padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 0.0, bottom: 16.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 35,
                          width: 35,

                          child: Center(
                            child: IconButton(
                              onPressed: () {

                                Navigator.pop(context);
                              },
                              icon: Image.asset(
                                'assets/icons/icon/awesome-arrow-right.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          title,
                          textAlign:TextAlign.left,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 16.0,color:Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),
                        ),



                      ],
                    ),
                  ))),
        ),
        Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
      ],
    );
  }


}
