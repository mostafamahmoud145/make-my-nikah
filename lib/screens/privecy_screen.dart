import 'dart:convert';

import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/colorsFile.dart';

class PrivecyScreen extends StatefulWidget {
  @override
  _PrivecyScreenState createState() => _PrivecyScreenState();
}

class _PrivecyScreenState extends State<PrivecyScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  final _key = UniqueKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            getTranslated(context, "back"),
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Text(
                          getTranslated(context, "policy"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 17.0,
                              color: AppColors.balck2,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    SizedBox()
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          Expanded(
            child: Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl: "https://makemynikah.com/privcy/",
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  initialMediaPlaybackPolicy:
                      AutoMediaPlaybackPolicy.always_allow,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ////=======================
  /* static final String tokenizationKey = 'sandbox_nd8wjs74_wvd373kdkt2j5755';

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var request = BraintreeDropInRequest(
                  tokenizationKey: tokenizationKey,
                  collectDeviceData: true,
                 */ /* googlePaymentRequest: BraintreeGooglePaymentRequest(
                    totalPrice: '4.20',
                    currencyCode: 'USD',
                    billingAddressRequired: false,
                  ),*/ /*
                  paypalRequest: BraintreePayPalRequest(
                    amount: '150.00',
                    displayName: 'Example company',
                  ),
                  cardEnabled: false,
                );
                final result = await BraintreeDropIn.start(request);
                if (result != null) {
                  String url='https://us-central1-influence2win-811cf.cloudfunctions.net/braintreePaypal';
                  print("aaaaa");
                  print(result.paymentMethodNonce.description);
                  print(result.paymentMethodNonce.nonce);
                 // showNonce(result.paymentMethodNonce);
                  print("aaaaa   $url?payment_method_nonce=${result.paymentMethodNonce.nonce }&device_data=${result.deviceData}" );
                  final http.Response response=await http.post(Uri.tryParse('$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));
                  print("hhhhhhhhhh");
                  print(response.body);
                  final paypalResult=jsonDecode(response.body);
                  if(paypalResult['result']=='success')
                    print("yakareeeeem");
                  else
                    {print("yaraaaaaaab");
                    print(paypalResult['result']);
                    print(paypalResult['data']);
                    }

                }
              },
              child: Text('LAUNCH NATIVE DROP-IN'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreeCreditCardRequest(
                  cardNumber: '4111111111111111',
                  expirationMonth: '12',
                  expirationYear: '2021',
                  cvv: '123',
                );
                final result = await Braintree.tokenizeCreditCard(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('TOKENIZE CREDIT CARD'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(
                  billingAgreementDescription:
                  'I hereby agree that flutter_braintree is great.',
                  displayName: 'Your Company',
                );
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL VAULT FLOW'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(amount: '13.37');
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL CHECKOUT FLOW'),
            ),
          ],
        ),
      ),
    );
  }*/
}
