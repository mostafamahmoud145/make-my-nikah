import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/methodes/bickFile.dart';
import 'package:grocery_store/widget/playVideo.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:image_picker/image_picker.dart';

import 'package:video_player/video_player.dart';


// ignore: must_be_immutable
class SendFileScreen extends StatefulWidget {
  SendFileScreen(
      {Key? key,
      required this.onSendMessage,
      required this.type,
      // required this.filePickerFuture,
      this.filee,
      this.extension})
      : super(key: key);
  final onSendMessage;
  final String type;
  var filee;
  String? extension;
  Key videoKey = UniqueKey();

  @override
  State<SendFileScreen> createState() => _SendFileScreenState();
}

class _SendFileScreenState extends State<SendFileScreen> {
  // final FilePickerResult filePickerFuture;
  VideoPlayerController? _controller;

  bool isPlaying = false;

  bool load = false;

  File? file;

  Uint8List? fileBytes;

  String fileName = "";

  String? filePath;

  // @override
  @override
  Widget build(BuildContext context) {
      file = widget.filee;
      filePath = file!.path;
      fileName = file!.uri.pathSegments.last;
    if (widget.type == "video") {
      _controller?.dispose();
      try {
        _controller = VideoPlayerController.file(file!)
          ..initialize().then((_) {});
      } catch (e) {
        log(e.toString());
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            widget.type == "video"
                ? Positioned.fill(
                    child: Container(
                      color: Colors.black,
                      height: double.infinity,
                      width: double.infinity,
                      child: PlayLocalVideoWidget(
                        key: widget.videoKey,
                        path: filePath!,
                        setsize: false,
                      ),
                    ),
                  )
                : widget.type == "image"
                    ? Container(
                        color: Colors.black,
                        height: double.infinity,
                        width: double.infinity,
                        // color: Colors.red,
                        child: kIsWeb == true
                            ? Image.memory(
                                fileBytes!,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                file!,
                                fit: BoxFit.cover,
                              ),
                      )
                    : Container(
                        color: Colors.black,
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: Icon(
                            Icons.file_present_rounded,
                            color: AppColors.red,
                          ),
                        ),
                      ),
            Positioned(
              top: AppPadding.p18.h,
              right: AppPadding.p10_6.w,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AssetsManager.exitImage,
                  width: AppSize.w72.w,
                  height: AppSize.w72.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: AppPadding.p10_6.w,
              bottom: AppSize.h25.h,
              child: InkWell(
                onTap: () async {
                  if (widget.type == "image") {
                    final _selectedImage = await pickImage();
                    if (_selectedImage != null) {
                      widget.filee = _selectedImage;
                      setState(() {});
                    }
                  } else if (widget.type == "video") {
                    final selectedVideo = await pickVideo();
                    print("selectedVideo1: $selectedVideo.path");
                    if (selectedVideo != null) {
                      widget.filee = selectedVideo;
                      filePath = selectedVideo.path;
                      widget.videoKey = UniqueKey();
                      setState(() {});
                    }
                  } else if (widget.type == "file") {
                    final _selectedFile = await picknewFile();
                    final _selectedFil = _selectedFile['selectedFile'];
                    final String extension = _selectedFile['extension'];
                    if (_selectedFile != null) {
                      widget.filee = _selectedFil;
                      widget.extension=extension;
                      setState(() {});
                    }
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: CircleAvatar(
                    maxRadius: 38,
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    child: SvgPicture.asset(
                      AssetsManager.imageRefrish,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSize.h41_3.h,
              left: AppPadding.p10_6.w,
              child: InkWell(
                onTap: () {
                  print("yeeeeeeeeeeeeeees ${widget.extension}");
                  widget.onSendMessage(widget.type, widget.filee, filePath,
                      extension: widget.extension);
                  Navigator.pop(context);
                },
                child: Container(
                  width: AppSize.w72.w,
                  height: AppSize.w72.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30000000),
                    gradient: LinearGradient(
                      stops: [0.0, 1.0],
                      colors: [
                        Color.fromRGBO(174, 156, 206, 1.0),
                        Color.fromRGBO(123, 108, 150, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        blurRadius: 16.0,
                        offset: Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.p20.w),
                    child: SvgPicture.asset(
                      AssetsManager.whiteSendIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
