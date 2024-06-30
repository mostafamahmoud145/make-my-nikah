
import 'package:flutter/material.dart';


Future<dynamic> navigateWithoutBack(context, Function() widgetBuilder)=>Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: (context)=>widgetBuilder()),
        (route) => false
);


Future<dynamic> navigateTo(context,Widget widget)=>Navigator.push(context,
  MaterialPageRoute(builder: (context)=>widget),
);


















