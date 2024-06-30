import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/walletFeature/utils/custom_widgets_for_payment_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import '../../../../config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../config/assets_manager.dart';

class StripePaymentBottomSheet extends StatefulWidget {
  final GroceryUser loggedUser;
  final double price;
  final String productName;
  final String productDesc;

  StripePaymentBottomSheet(
      {required this.loggedUser,
      required this.price,
      required this.productName,
      required this.productDesc});

  @override
  _StripePaymentBottomSheetState createState() =>
      _StripePaymentBottomSheetState();
}

class _StripePaymentBottomSheetState extends State<StripePaymentBottomSheet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpMonthController = TextEditingController();
  TextEditingController cardExpYearController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();

  FocusNode cardNumberFocus = FocusNode();
  FocusNode cardExpMonthFocus = FocusNode();
  FocusNode cardExpYearFocus = FocusNode();
  FocusNode cardCvvFocus = FocusNode();

  bool isSaveButtonEnabled = false;
  bool isPaymentSuccessful = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isPaymentSuccessful = false;
    isLoading = false;
    cardNumberController.addListener(_handleCardNumberChanges);
    cardExpMonthController.addListener(_handleCardExpMonthChanges);
    cardExpYearController.addListener(_handleCardExpYearChanges);
    cardCvvController.addListener(_checkIfFieldsAreCompleted);
  }

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    cardExpMonthController.dispose();
    cardExpYearController.dispose();
    cardCvvController.dispose();
    cardNumberFocus.dispose();
    cardExpMonthFocus.dispose();
    cardExpYearFocus.dispose();
    cardCvvFocus.dispose();
    super.dispose();
  }

  void _handleCardNumberChanges() {
    final cardNumber = cardNumberController.text.replaceAll(" ", "");
    if (cardNumber.length == 16) {
      cardExpMonthFocus.requestFocus();
    }
  }

  void _handleCardExpMonthChanges() {
    if (cardExpMonthController.text.length == 2) {
      cardExpYearFocus.requestFocus();
    }
  }

  void _handleCardExpYearChanges() {
    if (cardExpYearController.text.length == 2) {
      cardCvvFocus.requestFocus();
    }
  }

  void _checkIfFieldsAreCompleted() {
    setState(() {
      isSaveButtonEnabled = nameController.text.isNotEmpty &&
          cardNumberController.text.isNotEmpty &&
          cardNumberController.text.replaceAll(" ", "").length == 16 &&
          cardExpMonthController.text.length == 2 &&
          cardExpYearController.text.length == 2 &&
          cardCvvController.text.length == 3;
    });
  }

  void showSnack(String text, BuildContext context) {
    Container(
      width: AppSize.w506_6.w,
      height: AppSize.h72.h,
      child: Flushbar(
        margin: EdgeInsets.all(AppSize.w20.w),
        borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
        backgroundColor: AppColors.red,
        animationDuration: Duration(milliseconds: 300),
        isDismissible: true,
        // boxShadows: [AppShadow.primaryShadow],
        shouldIconPulse: false,
        duration: Duration(milliseconds: 8000),
        messageText: Text(
          '$text',
          style: TextStyle(
            fontFamily: getTranslated(context, 'Ithra'),
            fontSize: AppFontsSizeManager.s21_3.sp,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.3,
            color: AppColors.white,
          ),
        ),
      )..show(context),
    );
  }

  final _stripeDomain = 'https://api.stripe.com/v1/';


  // live keys for jeras
  // final _stripeSecretKeyTest =
  //     'pk_live_51LGf3zIZ9vncbvUGMeV92gCIdNJzyBX933ayRqrCTSy1DvUDIuYMGCCuBSl1p0qqfm6dUemwzWa8NXzPHft6kuHw00SYLyNXZ1';
  // final _stripeSecretKey2Test =
  //     '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';
// test keys
  final _stripeSecretKeyTest =
      'pk_test_51LGf3zIZ9vncbvUGFVRVNvyt75y86nq6llfnouDEjVpFhd4Cv6k5GWb0x5scZbwXKvquz5nrEDsP9ybBPh9Dobnx00V0eErOZu';
  final _stripeSecretKey2Test =
      'sk_test_51LGf3zIZ9vncbvUGqudunfAnPX7xqVZtXUc9q1bxDtbln66UP5kq5FleXQweWB8pQxeUtzjaXJxV4PgA7GFLMwEx00Ba6t1ZI3';

  // دالة لإنشاء عميل جديد وإرجاع معرف العميل
  Future<String> createCustomer(
      String email, String name, String description) async {
    // قم بتعيين العنوان الصحيح لنقطة النهاية في apiUrl
    final apiUrl = '${_stripeDomain}customers';
    String customerId;

    try {
      final searchResponse = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (searchResponse.statusCode == 200) {
        final customers =
            json.decode(searchResponse.body)['data'] as List<dynamic>;
        final existingCustomer = customers.firstWhere(
          (customer) => customer['email'] == email,
          orElse: () => null,
        );

        if (existingCustomer != null) {
          // العميل موجود بالفعل
          customerId = existingCustomer['id'];
        } else {
          final customerInfo = {
            'name': name,
            'email': email,
            'description': description,
          };

          final response = await http.post(
            Uri.parse(apiUrl),
            body: customerInfo,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Bearer $_stripeSecretKey2Test',
            },
          );

          if (response.statusCode == 200) {
            customerId = json.decode(response.body)['id'];
          } else {
            showSnack('${getTranslated(context, "error")}: فشل في إنشاء العميل',
                context);
            throw Exception('فشل في إنشاء العميل');
          }
        }
      } else {
        print(searchResponse.body);
        showSnack(
            '${getTranslated(context, "error")}: حدث خطأ أثناء البحث عن العميل',
            context);
        throw Exception('حدث خطأ أثناء البحث عن العميل');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return customerId;
  }

// دالة لإنشاء طريقة دفع (بطاقة) وإرجاع معرف الطريقة
  Future<String> createPaymentMethod(
      String cardNumber, String expMonth, String expYear, String cvc) async {
    // قم بتعيين العنوان الصحيح لنقطة النهاية في apiUrl
    final apiUrl = '${_stripeDomain}payment_methods';
    String paymentMethodId;

    try {
      final paymentInfo = {
        "type": 'card',
        'card[number]': cardNumber,
        'card[exp_month]': expMonth,
        'card[exp_year]': expYear,
        'card[cvc]': cvc,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: paymentInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKeyTest',
        },
      );

      if (response.statusCode == 200) {
        paymentMethodId = json.decode(response.body)['id'];
      } else {
        showSnack(
            '${getTranslated(context, "error")}: هناك خطأ بالبطاقة', context);
        throw Exception('فشل في إضافة طريقة الدفع,هناك خطأ بالبطاقة');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return paymentMethodId;
  }

// دالة لربط طريقة الدفع بالعميل
  Future<void> attachPaymentMethodToCustomer(
      String customerId, String paymentMethodId) async {
    // قم بتعيين العنوان الصحيح لنقطة النهاية في apiUrl
    final apiUrl = '${_stripeDomain}payment_methods/$paymentMethodId/attach';

    try {
      final attachmentInfo = {
        'customer': customerId,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: attachmentInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode != 200) {
        showSnack(
            '${getTranslated(context, "error")}: فشل في ربط طريقة الدفع بالعميل',
            context);
        throw Exception('فشل في ربط طريقة الدفع بالعميل');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }
  }

// دالة لتأكيد بطاقة العميل
  Future<bool> confirmCustomerCard(
      String customerId, String paymentMethodId) async {
    try {
      // قم بتعيين العنوان الصحيح لنقطة النهاية في apiUrl
      final apiUrl = '${_stripeDomain}customers/$customerId';

      final attachmentInfo = {
        'invoice_settings[default_payment_method]': paymentMethodId,
      };

      final searchResponse = await http.post(
        Uri.parse(apiUrl),
        body: attachmentInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (searchResponse.statusCode == 200) {
        return true;
      } else {
        showSnack(
            '${getTranslated(context, "error")}: فشل في تأكيد بطاقة العميل',
            context);
        throw Exception('فشل في تأكيد بطاقة العميل');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }
  }

  // دالة لإنشاء منتج وإرجاع معرف المنتج
  Future<String> createProduct(String name, String description) async {
    final apiUrl = 'https://api.stripe.com/v1/products';
    String productId;

    try {
      final productInfo = {
        'name': name,
        'description': description,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: productInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        productId = productData['id'];
      } else {
        showSnack(
            '${getTranslated(context, "error")}: فشل في إنشاء المنتج', context);
        throw Exception('فشل في إنشاء المنتج');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return productId;
  }

// دالة لإنشاء سعر للمنتج وإرجاع معرف السعر
  Future<String> createPrice(
      String productId, int amount, String currency) async {
    final apiUrl = 'https://api.stripe.com/v1/prices';
    String priceId;

    try {
      final priceInfo = {
        'unit_amount': amount.toString(),
        'currency': currency,
        'product': productId,
      };
      print(priceInfo);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: priceInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode == 200) {
        final priceData = json.decode(response.body);
        priceId = priceData['id'];
      } else {
        showSnack(
            '${getTranslated(context, "error")}: فشل في إنشاء السعر', context);
        throw Exception('فشل في إنشاء السعر');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return priceId;
  }

// دالة لإنشاء فاتورة وإرجاع معرف الفاتورة
  Future<String> createInvoice(String customerId, String description,
      String paymentMethodId, String priceId) async {
    final apiUrl = 'https://api.stripe.com/v1/invoiceitems';
    String invoiceId;

    try {
      final invoiceInfo = {
        'customer': customerId,
        'price': priceId,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: invoiceInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode == 200) {
        final invoiceData = json.decode(response.body);
        invoiceId = invoiceData['id'];
      } else {
        showSnack('${getTranslated(context, "error")}: فشل في إنشاء الفاتورة',
            context);
        throw Exception('فشل في إنشاء الفاتورة');
      }
    } catch (error) {
      String e = error.toString().split(':').last;

      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return invoiceId;
  }

// دالة لربط العميل بالفاتورة ودفعها
  Future<String> linkCustomerToInvoiceAndPay(
      String customerId, String invoiceId, String paymentMethodId) async {
    final apiUrl = 'https://api.stripe.com/v1/invoices';
    String invoiceId;

    try {
      final payInfo = {
        'customer': customerId,
        "days_until_due": "7",
        "collection_method": "send_invoice"
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: payInfo,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode == 200) {
        final invoiceData = json.decode(response.body);
        invoiceId = invoiceData['id'];
      } else {
        showSnack('${getTranslated(context, "error")}: فشل في إنشاء الفاتورة',
            context);
        throw Exception('فشل في إنشاء الفاتورة');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }

    return invoiceId;
  }

// دالة لإرسال العميل للفاتورة ودفعها
  Future<void> sendCustomerToInvoiceAndPay(
      String customerId, String invoiceId, String paymentMethodId) async {
    final apiUrl = 'https://api.stripe.com/v1/invoices/$invoiceId/pay';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $_stripeSecretKey2Test',
        },
      );

      if (response.statusCode == 200) {
        print('تم دفع الفاتورة بنجاح');
        final invoiceData = json.decode(response.body);
        print(invoiceData);

        if (invoiceData['amount_paid'] == invoiceData['amount_due']) {
          print('الفاتورة تم دفعها بنجاح');
          setState(() {
            isPaymentSuccessful = true;
          });
        } else {
          print('الفاتورة لم تتم دفعها بشكل كامل');
          showSnack(
              '${getTranslated(context, "error")} : الفاتورة لم تتم دفعها بشكل كامل',
              context);
          throw Exception('الفاتورة لم تتم دفعها بشكل كامل');
          // يمكنك التعامل مع هذه الحالة حسب احتياجاتك
        }
      } else {
        print(response.body);
        showSnack('${getTranslated(context, "error")} : حدث خطأ أثناء الدفع',
            context);
        throw Exception('حدث خطأ أثناء الدفع');
      }
    } catch (error) {
      String e = error.toString().split(':').last;
      showSnack('${getTranslated(context, "error")}: $e', context);
      throw Exception('حدث خطأ: $error');
    }
  }

  Future<void> completePaymentProcess(
      String email,
      String name,
      String description,
      String cardNumber,
      String expMonth,
      String expYear,
      String cvc,
      String productName,
      String productDescription,
      int productAmount,
      String productCurrency,
      String invoiceDescription) async {
    try {
      // Step 1: Create a customer
      final customerId = await createCustomer(email, name, description);

      // Step 2: Create a payment method
      final paymentMethodId =
          await createPaymentMethod(cardNumber, expMonth, expYear, cvc);

      // Step 3: Attach the payment method to the customer
      await attachPaymentMethodToCustomer(customerId, paymentMethodId);

      await confirmCustomerCard(customerId, paymentMethodId);

      // Step 4: Create a product
      final productId = await createProduct(productName, productDescription);

      // Step 5: Create a price for the product
      final priceId =
          await createPrice(productId, productAmount, productCurrency);

      // Step 6: Create an invoice
      final invoiceId = await createInvoice(
          customerId, invoiceDescription, paymentMethodId, priceId);

      // Step 7: Link the customer to the invoice
      final invoiceId2 = await linkCustomerToInvoiceAndPay(
          customerId, invoiceId, paymentMethodId);

      // Step 8: link the invoice
      await sendCustomerToInvoiceAndPay(
          customerId, invoiceId2, paymentMethodId);

      print('Payment process completed successfully');
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: AppPadding.p25.h,
                right: AppPadding.p42_6.w,
                left: AppPadding.p42_6.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: AppSize.h30.h,
                  ),
                  Align(
                    alignment: getTranslated(context, "lang") == "ar"
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        AssetsManager.redCancelIconPath,
                        width: AppSize.w40.r,
                        height: AppSize.h40.r,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h33.h,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          getTranslated(context, "enterTheName"),
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: getTranslated(context, 'Ithra'),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h21_3.h,
                        ),

                        ///NAME///
                        TextFormFieldWidget2(
                          onTap: () {},
                          controller: nameController,
                          context: context,
                          horizontalPadding: AppSize.w21_3,
                          name: "",
                          fontFamily: getTranslated(context, "Ithralight"),
                          inputFontFamily: getTranslated(context, "Ithralight"),
                          fontColor: AppColors.black1,
                          fontSize: AppFontsSizeManager.s21_3,
                          radius: AppRadius.r10_6,
                          labelColor: AppColors.grey,
                        ),
                        SizedBox(height: AppSize.h32.h),

                        ///NUM_CARD///
                        Text(
                          getTranslated(context, "cardNum"),
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: getTranslated(context, "Ithra"),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h21_3.h,
                        ),
                        TextFormFieldWidget2(
                          onTap: () {},
                          focusNode: cardNumberFocus,
                          controller: cardNumberController,
                          context: context,
                          name: '',
                          fontFamily: getTranslated(context, "Ithralight"),
                          inputFontFamily: getTranslated(context, "Ithralight"),
                          fontColor: AppColors.black1,
                          fontSize: AppFontsSizeManager.s21_3,
                          radius: AppRadius.r10_6,
                          labelColor: AppColors.grey,
                          horizontalPadding: AppSize.w21_3,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            CardNumberInputFormatter(),
                          ],
                        ),
                        SizedBox(height: AppSize.h32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                getTranslated(context, "cardMonth"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: getTranslated(context, 'Ithra'),
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: AppSize.w21_3.w,
                            ),
                            Expanded(
                              child: Text(
                                getTranslated(context, "cardYear"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: getTranslated(context, 'Ithra'),
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h21_3.h,
                        ),
                        Row(
                          children: [
                            ///MONTH///
                            Expanded(
                              child: TextFormFieldWidget2(
                                onTap: () {},
                                focusNode: cardExpMonthFocus,
                                controller: cardExpMonthController,
                                context: context,
                                name: '',
                                fontFamily:
                                    getTranslated(context, "Ithralight"),
                                fontColor: AppColors.black1,
                                fontSize: AppFontsSizeManager.s21_3,
                                inputFontFamily:
                                    getTranslated(context, "Ithralight"),
                                horizontalPadding: AppSize.w21_3,
                                radius: AppRadius.r10_6,
                                labelColor: AppColors.grey,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return getTranslated(context, "required");
                                  } else if (cardExpMonthController
                                          .text.length !=
                                      2) {
                                    return getTranslated(
                                        context, "incorrectData");
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: AppSize.w21_3.w),

                            ///YEAR///
                            Expanded(
                              child: TextFormFieldWidget2(
                                onTap: () {},
                                focusNode: cardExpYearFocus,
                                controller: cardExpYearController,
                                context: context,
                                name: '',
                                fontFamily:
                                    getTranslated(context, "Ithralight"),
                                fontColor: AppColors.black1,
                                fontSize: AppFontsSizeManager.s21_3,
                                horizontalPadding: AppSize.w21_3,
                                inputFontFamily:
                                    getTranslated(context, "Ithralight"),
                                radius: AppRadius.r10_6,
                                labelColor: AppColors.grey,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return getTranslated(context, "required");
                                  } else if (cardExpYearController
                                          .text.length !=
                                      2) {
                                    return getTranslated(
                                        context, "incorrectData");
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.h32.h),
                        Text(
                          getTranslated(context, "ccv"),
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: getTranslated(context, 'Ithra'),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h21_3.h,
                        ),
                        TextFormFieldWidget2(
                          onTap: () {},
                          focusNode: cardCvvFocus,
                          context: context,
                          fontFamily: getTranslated(context, "Ithralight"),
                          fontColor: AppColors.black1,
                          fontSize: AppFontsSizeManager.s21_3,
                          radius: AppRadius.r10_6,
                          inputFontFamily: getTranslated(context, "Ithralight"),
                          horizontalPadding: AppSize.w21_3,
                          labelColor: AppColors.grey,
                          controller: cardCvvController,
                          name: '',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, "required");
                            } else if (cardCvvController.text.length != 3) {
                              return getTranslated(context, "incorrectData");
                            }
                            return null;
                          },
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                        SizedBox(height: AppSize.h64.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: AppPadding.p26_5.h),
                          child: Center(
                            child: Container(
                              width: AppSize.w506_6.w,
                              height: AppSize.h66_6.h,
                              decoration: BoxDecoration(
                                  color: AppColors.primary2,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r20.r)),
                              child: PrimaryButton(
                                width: AppSize.w506_6.w,
                                height: AppSize.h66_6.h,
                                onPress: () async {
                                  setState(() {
                                    isLoading = true;
                                    print(isLoading);
                                  });

                                  FocusScope.of(context).unfocus();
                                  // اتصل بدالة الدفع هنا
                                  // await completePaymentProcess(
                                  //     'customer3@example.com',
                                  //     'Customer Name222',
                                  //     'Customer Description',
                                  //     '4242424242424242',
                                  //     '01',
                                  //     '25',
                                  //     '123',
                                  //     'Product Name',
                                  //     'Product Description',
                                  //     750,
                                  //     'usd',
                                  //     'Invoice Description');
                                  if (formKey.currentState!.validate()) {
                                    await completePaymentProcess(
                                      '${widget.loggedUser.phoneNumber}@gmail.com',
                                      nameController.text,
                                      widget.loggedUser.uid.toString(),
                                      cardNumberController.text,
                                      cardExpMonthController.text,
                                      cardExpYearController.text,
                                      cardCvvController.text,
                                      'make my nekah App Order',
                                      widget.productName.toString(),
                                      (widget.price * 100).toInt() +
                                          (widget.price * 100 * 0.05).toInt(),
                                      'usd',
                                      '${widget.loggedUser.name}  --  ${widget.loggedUser.phoneNumber}  --  ${widget.loggedUser.uid}',
                                    );
                                    if (isPaymentSuccessful) {
                                      Navigator.pop(
                                          context, isPaymentSuccessful);
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                    print(isLoading);
                                  });
                                },
                                text: getTranslated(context, "PaymentProcess"),
                                textSize: AppFontsSizeManager.s20.sp,
                                buttonRadius: AppRadius.r19.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
