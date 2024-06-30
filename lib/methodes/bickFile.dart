import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';


pickImage() async {
  {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print("$image vvvvvvvv");
    if (image != null) {
    
        final _selectedImage = File(image!.path);
        return _selectedImage;

    }
  }
}

pickVideo() async {
  final ImagePicker _picker = ImagePicker();
  XFile? vedioo = await _picker.pickVideo(source: ImageSource.gallery);

  if (vedioo != null) {
    final _selectedVedio = File(vedioo!.path);

    return _selectedVedio;
  }
}

 Future<Map<String, dynamic>> picknewFile() async {
  XTypeGroup pdfTypeGroup = XTypeGroup(
      label: 'PDFs', extensions: ['pdf', 'doc', 'docx', 'pages', '_pdf'], mimeTypes: [
    'application/pdf',
    'application/_pdf',
    'application/docx',
    'application/doc',
    'application/pages',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ]);

  XFile? file = await openFile(
    acceptedTypeGroups: [pdfTypeGroup],
  );

  if (file != null) {
    final directory = await getTemporaryDirectory();
    final fileName = path.basename(file.path);
    final localFilePath = path.join(directory.path, fileName);
    final fileBytes = await file.readAsBytes();
    final File _selectedFile = File(localFilePath);
    await _selectedFile.writeAsBytes(fileBytes);
    final extension = await convertUriToFile(file.path);
    return {"selectedFile" : _selectedFile, "extension" : extension};
  }
  return {"selectedFile" : null, "extension" : null};
}

Future<String?> convertUriToFile(pathh) async {
  try {
    String uriString = pathh;
    File file = await toFile(uriString);// Converting uri to file
    String extension = path.extension(file.path);
    return extension;
  } on UnsupportedError catch (e) {
    print(e.message); // Unsupported error for uri not supported
  } on IOException catch (e) {
    print(e); // IOException for system error
  } on Exception catch (e) {
  }
  return null;
}
