import 'dart:io';

import 'package:flutter/services.dart';
import 'package:grocery_store/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfParagraphApi {
  static Future<File> generate() async {
    final pdf = Document();

    final customFont = Font.ttf(await rootBundle.load('assets/fonts/open_sans.ttf'));
    final image = (await rootBundle.load('assets/icons/icon/6.png')).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image), width: 50, height: 50, fit: pw.BoxFit.fill),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("الاسم",textDirection: TextDirection.rtl, style: pw.TextStyle( font: customFont,)),
                      pw.Text("Customer Address"),
                      pw.Text("Customer City"),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Max Weber"),
                      pw.Text("Weird Street Name 1"),
                      pw.Text("77662 Not my City"),
                      pw.Text("Vat-id: 123456"),
                      pw.Text("Invoice-Nr: 00001")
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Dear Customer, thanks for buying at Flutter Explained, feel free to see the list of items below."),
              pw.SizedBox(height: 25),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text("statment", textAlign: pw.TextAlign.left)),
                        pw.Expanded(child: pw.Text("currency", textAlign: pw.TextAlign.right)),
                        pw.Expanded(child: pw.Text("total", textAlign: pw.TextAlign.right)),
                        pw.Expanded(child: pw.Text("date", textAlign: pw.TextAlign.right)),
                      ],
                    )

                  ],
                ),
              ),
              pw.SizedBox(height: 25),
              pw.Text("Thanks for your trust, and till the next time."),
              pw.SizedBox(height: 25),
              pw.Text("Kind regards,"),
              pw.SizedBox(height: 25),
              pw.Text("Max Weber")
            ],
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Widget buildCustomHeader() => Container(
    padding: EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(width: 2, color: PdfColors.blue)),
    ),
    child: Row(
      children: [
        PdfLogo(),
        SizedBox(width: 0.5 * PdfPageFormat.cm),
        Text(
          'Create Your PDF',
          style: TextStyle(fontSize: 20, color: PdfColors.blue),
        ),
      ],
    ),
  );

  static Widget buildCustomHeadline() => Header(
    child: Text(
      'My Third Headline',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: PdfColors.white,
      ),
    ),
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(color: PdfColors.red),
  );

  static Widget buildLink() => UrlLink(
    destination: 'https://flutter.dev',
    child: Text(
      'Go to flutter.dev',
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: PdfColors.blue,
      ),
    ),
  );

  static List<Widget> buildBulletPoints() => [
    Bullet(text: 'First Bullet'),
    Bullet(text: 'Second Bullet'),
    Bullet(text: 'Third Bullet'),
  ];
}
