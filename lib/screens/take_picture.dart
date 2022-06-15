import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:awaslubang/screens/create_report_success.dart';
import 'package:awaslubang/baseurl.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  // data to submit to api
  late double _latitude;
  late double _longitude;
  late String _address;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  void _submitReport() async {
    log("masukkan");
    var url = Uri.parse(Baseurl.staging + 'aduans/');
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    var body = {
      "latitude": _latitude.toString(),
      "longitude": _longitude.toString(),
      "alamat": _address,
      "status": "hantar"
    };

    var request = http.MultipartRequest('POST', url)
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(
          await http.MultipartFile.fromPath('gambar', _imageFileList![0].path));

    var response = await request.send();
    Get.to(SuccessPage());
  }

  @override
  void initState() {
    _onImageButtonPressed(ImageSource.camera);
    var data = Get.arguments;
    _latitude = data[0];
    _longitude = data[1];
    _address =
        "${data[2][0].street}, ${data[2][0].subLocality}, ${data[2][0].locality}";

    super.initState();
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _previewImages() {
    if (_imageFileList != null) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Image.file(File(_imageFileList![index].path)),
              );
            },
            itemCount: _imageFileList!.length,
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return InkWell(
        onTap: () {
          _onImageButtonPressed(ImageSource.camera);
        },
        child: FloatingActionButton(
          onPressed: () {
            isVideo = false;
            _onImageButtonPressed(ImageSource.camera);
          },
          heroTag: 'image2',
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt),
        ),
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 47, 11, 131),
        title: Text(
          "Take Photo",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return _handlePreview();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : _handlePreview(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _submitReport();
        },
        label: const Text('Confirm'),
        backgroundColor: Color.fromARGB(255, 47, 11, 131),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
