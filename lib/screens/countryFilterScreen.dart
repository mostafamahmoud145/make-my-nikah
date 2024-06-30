import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../widget/chooseItem.dart';


class CountryFilterScreen extends StatefulWidget {
  final int screen;

  const CountryFilterScreen({Key? key,required this.screen}) : super(key: key);

  @override
  State<CountryFilterScreen> createState() => _ChooseFilterScreenState();
}

class _ChooseFilterScreenState extends State<CountryFilterScreen> {

  TextEditingController countryController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
          children: [
            SafeArea(child: Padding(
              padding: EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 40.0, bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Image.asset(
                          getTranslated(context, "back",), width: 20, height: 20,),
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 20,),
                        if(widget.screen == 1)
                        Text(
                          getTranslated(context, "country"),
                          style: TextStyle(color: AppColors.reddark2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 20),)

                      else if(widget.screen == 2)
                        Text(
                          getTranslated(context, "nationality"),
                          style: TextStyle(color: AppColors.reddark2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 20),)

                    ],
                  ),
                  InkWell(
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.reddark2,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "clean"),
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"), color: AppColors.white,
                              fontSize: 12.0,fontWeight: FontWeight.normal ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
              child: Column(
                children: [
                   TextField(
                          readOnly: true,
                          controller: countryController,
                          onTap: ()
                          {
                          showCountryPicker(
                          context: context,
                          showPhoneCode: false,

                          // optional. Shows phone code before the country name.
                          onSelect: (Country country) {
                          setState(() {
                           countryController.text = country.name;
                          });
                          },
                            countryListTheme: CountryListThemeData(
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: AppColors.reddark2,
                                    ),
                                  ),
                                ),
                            bottomSheetHeight: 850, // Optional. Country list modal height
                          //Optional. Sets the border radius for the bottomsheet.
                          borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                            )
                          ));
                          },
                          style: TextStyle(
                            color: AppColors.black2,
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 20
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: getTranslated(context, "favoritecountry"),
                            fillColor: AppColors.white1,
                            hintStyle: TextStyle(
                              color: AppColors.grey2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 16
                            ),

                          ),
                        ),

                ],
              ),
            ),
              if(widget.screen == 1)


            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.greendark2,
                        AppColors.red1
                      ]
                  )
              ),
              height: 47,
              child: MaterialButton(
                onPressed: () async {

                },
                //   color: AppColors.red1,
                child: Text(getTranslated(context, "save"),
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    color: AppColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

          ]
      ),
    );
  }
}