import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mobileremote/classes/vision_provider.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'data_storage.dart';

// Source: https://flutter.dev/docs/cookbook/plugins/picture-using-camera#5-take-a-picture-with-the-cameracontroller
// [Camera] widget displays the camera and barcode scanner
class Camera extends StatefulWidget {
  final String itemToGuess;
  final Function updateParent;
  final String imageLocation;
  final String cameraImgOverlay;

  Camera(
      {this.itemToGuess,
      this.updateParent,
      this.imageLocation,
      this.cameraImgOverlay});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  int _indexedStackIndex = 0;
  File _image;
  UserDataContainerState _dataContainer;
  bool _isLoading = false;
  CameraDescription _camera; // Selected camera
  CameraController _controller; // Controller for the camera
  Future<void> _initializeControllerFuture; // Used for the FutureBuilder

  // Initializes the camera on widget load
  @override
  void initState() {
    super.initState();
    // Waits on the [loadCameras()] method to initialize [initializeControllerFuture]
    loadCameras().then((result) {
      setState(() {
        _controller = CameraController(_camera, ResolutionPreset.max);
        _initializeControllerFuture = _controller.initialize();
      });
    });
    _indexedStackIndex = 0;
  }

  // Disposes the CameraController when this widget is no longer used
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Get a specific camera from the list of available cameras.
  Future<void> loadCameras() async {
    final cameras = await availableCameras();
    _camera = cameras.first;
  }

  // Takes a picture with the camera and opens the [DisplayPictureScreen] widget to show picture to user
  void onCameraButtonPressed(BuildContext context) async {
    try {
      // Construct the path where the image should be saved using the pattern package.
      final path = join(
        // Store the picture in the temp directory.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture
      await _controller.takePicture(path);

      _image = File(path);

      processImage(context, path, widget.itemToGuess);
    } catch (e) {
      print(e);
    }
  }

  void processImage(
      BuildContext context, String filePath, String itemToGuess) async {
    Uint8List imageBytes = await File(filePath).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    print(base64Image);

    VisionProvider vs = new VisionProvider();
    bool isCorrect = await vs.search(base64Image, itemToGuess);

    if (isCorrect) {
      setState(() {
        _indexedStackIndex = 1;
      });
    }
    _dataContainer.isAnswered = true;
    _dataContainer.isCorrect = isCorrect;
    widget.updateParent();
  }

  Widget generatePicture() {
    if (_image != null) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFDCE140)),
                color: Color(0xFFDCE140),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Image.file(_image),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                widget.cameraImgOverlay,
                scale: 5,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    onCameraButtonPressed(context);
                  },
                  child: Image.asset(
                    widget.imageLocation, scale: 7,
//              backgroundColor: kPrimaryColorDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Text('');
  }

  // User interface of the widget
  @override
  Widget build(BuildContext context) {
    _dataContainer = UserDataContainer.of(context);
    return Column(
      children: <Widget>[
        IndexedStack(
          index: _indexedStackIndex,
          children: <Widget>[
            Stack(
              children: <Widget>[
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDCE140)),
                            color: Color(0xFFDCE140),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ),
                      );
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      widget.cameraImgOverlay,
                      scale: 5,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          onCameraButtonPressed(context);
                        },
                        child: Image.asset(
                          widget.imageLocation, scale: 7,
//              backgroundColor: kPrimaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            generatePicture()
          ],
        ),
      ],
    );
//    return Scaffold(
//      body: LoadingOverlay(
//        isLoading: _isLoading,
//        child: FutureBuilder<void>(
//          future: _initializeControllerFuture,
//          builder: (context, snapshot) {
//            if (snapshot.connectionState == ConnectionState.done) {
//              // If the Future is complete, display the preview.
//              return CameraPreview(_controller);
//            } else {
//              // Otherwise, display a loading indicator.
//              return Center(child: CircularProgressIndicator());
//            }
//          },
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      floatingActionButton: Stack(
//        children: <Widget>[
//          // Camera button
//          Align(
//            alignment: Alignment.bottomCenter,
//            child: FloatingActionButton(
//                child: Icon(Icons.camera_alt),
////              backgroundColor: kPrimaryColorDark,
//                onPressed: () {
//                  onCameraButtonPressed(context);
//                }),
//          ),
//        ],
//      ),
//    );
  }
}
