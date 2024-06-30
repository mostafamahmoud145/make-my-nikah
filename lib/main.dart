import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/Utils/app_life_cycle-observer.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/blocs/meet_cubit/startCallScreen.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/repositories/authentication_repository.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:grocery_store/screens/firstLanchScreen.dart';
import 'package:grocery_store/screens/forceUpdateScreen.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/apple_sign_up_cubit/apple_sign_up_cubit.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/gmail_sign_up_cubit/gmail_sign_up_cubit.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/setting_cubit/setting_cubit.dart';
import 'package:grocery_store/screens/languageScreen.dart';
import 'package:grocery_store/screens/moreScreen.dart';
import 'package:grocery_store/screens/sign_up_screen.dart';
import 'package:grocery_store/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/screens/splash_screens/first_splash.dart';
import 'package:grocery_store/services/shared%20preferences/shared_preferences.dart';
import 'package:grocery_store/screens/walletFeature/utils/service/strip_cubit/strip_payment_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'blocs/meet_cubit/call_cubit/call_cubit.dart';
import 'localization/language_constants.dart';
import 'localization/set_localization.dart';
import 'methodes/change_user_call_state.dart';
import 'models/DefaultFirebaseConfig.dart';
import 'screens/CoacheAppoinmentFeature/utils/service/CoachAppointmentCubit/coach_appointment_cubit.dart';
import 'screens/GirlAppointmentFeature/utils/service/GirlAppointmentCubit/girl_appointment_cubit.dart';
import 'screens/home_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? payload;
void main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      Platform.isAndroid || Platform.isIOS
          ? await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails()
          : null;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    payload = notificationAppLaunchDetails!.notificationResponse!.payload;
  }
  await CashHelper.init();
  AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
  appLifecycleObserver.initialize();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  //Stripe.publishableKey = "pk_test_51LGf3zIZ9vncbvUGFVRVNvyt75y86nq6llfnouDEjVpFhd4Cv6k5GWb0x5scZbwXKvquz5nrEDsP9ybBPh9Dobnx00V0eErOZu";
  // Stripe.publishableKey =
  //     "pk_live_51LGf3zIZ9vncbvUGMeV92gCIdNJzyBX933ayRqrCTSy1DvUDIuYMGCCuBSl1p0qqfm6dUemwzWa8NXzPHft6kuHw00SYLyNXZ1";
  // Stripe.merchantIdentifier = 'merchant.com.MakeMyNikah';
  // if (Platform.isIOS) await Stripe.instance.applySettings();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<StripPaymentCubit>(
          create: (context) => StripPaymentCubit(),
        ),
        BlocProvider<CoachAppointmentCubit>(
          create: (context) => CoachAppointmentCubit(),
        ),
        BlocProvider<GirlAppointmentCubit>(
          create: (context) => GirlAppointmentCubit(),
        ),
        BlocProvider<SettingCubit>(
          create: (context) => SettingCubit(),
        ),
        BlocProvider<GmailSignUpCubit>(
          create: (context) => GmailSignUpCubit(),
        ),
        BlocProvider<AppleSignUpCubit>(
          create: (context) => AppleSignUpCubit(),
        ),
      ],
      child: MyApp(initialLink, payload: payload),
    ),
  );
}

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData? initialLink;
  final String? payload;

  const MyApp(
    this.initialLink, {
    Key? key,
    this.payload,
  }) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}
 GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _local;
  bool firstLansh = false;
  bool _isCall = false;
  bool _hasNavigatedSuccessfully = false;
  Timer? _resetTimer;
  void setLocale(Locale locale) {
    setState(() {
      _local = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._local = locale;
      });
    });

    getFirstLanch().then((ss) {
      setState(() {
        this.firstLansh = ss;
      });
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseDatabase.instance
          .ref('userCallState')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('callState')
          .onDisconnect()
          .set('closed');
    }
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      EasyDebounce.debounce('checkNavigation', Duration(milliseconds: 1000), () {
        checkAndNavigationCallingPage(context,);
      },) ;
    }
    super.didChangeAppLifecycleState(state);

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));

    if (this._local == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.purple.shade800)),
        ),
      );
    } else {
      Responsive.init(context);

      return ScreenUtilInit(
          designSize: Size(573, 1215),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nikah',
          locale: _local,
          navigatorKey: navigatorKey,
          supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR') ],
          localizationsDelegates: [
            SetLocalization.localizationsDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocal, supportedLocales) {
            for (var local in supportedLocales) {
              if (local.languageCode == deviceLocal!.languageCode &&
                  local.countryCode == deviceLocal.countryCode) {
                return deviceLocal;
              }
            }
            return supportedLocales.first;
           // return _local;
          },
          theme: ThemeData(
            fontFamily: 'montserrat',
            primaryColor: Color.fromRGBO(207, 0, 54, 1.0),
            //Color(0xFF7b6c94),
            colorScheme: ColorScheme.light(primary: Color.fromRGBO(207, 0, 54, 1.0)),
            //const Color(0xFF7b6c94)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle
                    .dark), //this is new way to change icons color of status bar
          ),
          initialRoute: _isCall ? '/startCallScreen' : '/',
          routes: {
            '/': (context) =>
                firstLansh ? FirstScreen() :
                // FirstScreen(),
                SplashScreen(widget.initialLink),
            '/home': (context) => HomeScreen(),
            '/Register_Type': (context) => SignUpScreen(),
            '/ForceUpdateScreen': (context) => ForceUpdateScreen(),
            '/startCallScreen': (context) {
              print('start call route');
              endCall();
              return BlocProvider(
                create: (context) => CallCubit(),
                child: startCallScreen(),
              );
            },
            '/lang': (context) => LanguageScreen(),
            '/more': (context) => MoreScreen(),
          },
        );
    });
    }
  }

  Future<void> checkAndNavigationCallingPage(BuildContext? contexts) async {
    if (_hasNavigatedSuccessfully) {
      'Navigation Canceled'.logPrint();
      return;
    }
    var currentCall = await getCurrentCall();
    if (_isCall) {
      _isCall = false;
    } else {
      if (currentCall != null) {
        _isCall = true;
        //navigatorKey.currentState!.pushNamed('/startCallScreen');
        try {
          if (navigatorKey.currentState != null) {
            'Navigation to Call Screen using NavKey'.logPrint();
            navigatorKey.currentState!.pushNamed('/startCallScreen');
            _setNavigationFlag();
          } else if (contexts != null && Navigator.of(contexts, rootNavigator: true).mounted) {
            'Navigation to Call Screen using context'.logPrint();
            Navigator.of(contexts).pushNamed("/startCallScreen");
            _setNavigationFlag();

          }
        }catch (e){
          _clearNavigationFlag();
        }


      }
    }
  }

  void _setNavigationFlag() {
    'Turning on navigation Flag'.logPrint();
    _hasNavigatedSuccessfully = true;  // Mark that navigation was successful
    // Reset the flag after a specified duration
    _resetTimer?.cancel();  // Cancel any existing timer
    _resetTimer = Timer(Duration(seconds: 10), () {
      _hasNavigatedSuccessfully = false;
    });
  }
  void _clearNavigationFlag() {
    'Clear navigation Flag'.logPrint();

    _hasNavigatedSuccessfully = false;  // Mark that navigation was successful
    // Reset the flag after a specified duration
    _resetTimer?.cancel();  // Cancel any existing timer
  }
  void endCall() {
    _isCall = false;
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    //var calls = await CallKeep.instance.activeCalls();
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls.isNotEmpty) {
      return calls[0];
    } else {
      if (FirebaseAuth.instance.currentUser != null) {

        'No Call Found'.printError();
        await changeUserState(
            userId: FirebaseAuth.instance.currentUser!.uid, state: 'closed');
      }
      return null;
    }
  }
}

mayAppCheckCall({BuildContext? contexts}) {
  EasyDebounce.debounce('checkNavigation', Duration(milliseconds: 1000),(){
    _MyAppState().checkAndNavigationCallingPage(contexts);
  });
}

mayAppChangIsCall() {
  _MyAppState().endCall();
}
