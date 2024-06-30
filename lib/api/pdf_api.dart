import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:grocery_store/openFile/open_file.dart';


class PdfApi {

  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();
    print ("pdf1");

    pdf.addPage(Page(
      build: (context) => Center(
        child: Text(text, style: TextStyle(fontSize: 48)),
      ),
    ));
    print ("pdf2");

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    try {
      final bytes = await pdf.save();

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      print('Document saved at ${file.path}');
      openPdfFile(file.path);
      return file;
    } catch (e) {
      print('Error saving document: $e');
      rethrow; // Optionally rethrow to handle the error outside this function
    }
  }
  static void openPdfFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    print('Open file result: ${result.type} ${result.message}');
  }

  ///TODO: packages
  // static Future openFile(File file) async {
  //   final url = file.path;
  //   await OpenFile.open(url);
  // }
}
