import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileremote/components/camera.dart';
import 'package:mobileremote/components/data_storage.dart';

import '../constants.dart';

class ShowMeGamePage extends StatefulWidget {
  static const String id = 'selected_game';
  @override
  _ShowMeGamePageState createState() => _ShowMeGamePageState();
}

class _ShowMeGamePageState extends State<ShowMeGamePage> {
  UserDataContainerState _dataContainer;
  List<List<String>> _questionsAnswers = [
    ['Show me an apple!', 'apple', 'assets/apple_overlay.png'],
    ['Show me a banana!', 'banana', 'assets/apple_overlay.png'],
  ];
  int indexCount = 0;

  // Initializes the camera on widget load
  @override
  void initState() {
    super.initState();
  }

  Widget generateQuestionPrompt() {
    if (_dataContainer.isAnswered) {
      if (_dataContainer.isCorrect) {
        return Text('Great job!',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 24,
            ));
      } else {
        return Text('Try again!',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 24,
            ));
      }
    }
    return Text(
      _questionsAnswers[indexCount][0],
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
        fontSize: 24,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dataContainer.isCorrect = false;
    _dataContainer.isAnswered = false;
  }

  void updateParent() {
    setState(() {});
  }

  String getImageLocation() {
    if (_dataContainer.isAnswered) {
      if (_dataContainer.isCorrect) {
        return 'assets/next_question.png';
      } else {
        return 'assets/camera_click.png';
      }
    }
    return 'assets/camera_click.png';
  }

  String getOverlayImage() {
    if (_dataContainer.isAnswered) {
      if (_dataContainer.isCorrect) {
        return 'assets/apple_overlay_good.png';
      } else {
        return 'assets/apple_overlay_bad.png';
      }
    }
    return 'assets/apple_overlay.png';
  }

  @override
  Widget build(BuildContext context) {
    _dataContainer = UserDataContainer.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF7FB2B1),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Image.asset(
                'assets/back_button.png',
                scale: 5,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Image.asset(
                'assets/help_button.png',
                scale: 5,
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            kAppName,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.fredokaOne(fontSize: 24, color: Color(0xFFFFDC66)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Question ${indexCount + 1} / ${_questionsAnswers.length}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: generateQuestionPrompt(),
                      ),
                      SizedBox(height: 30),
                      Flexible(
                        child: Camera(
                          itemToGuess: _questionsAnswers[indexCount][1],
                          updateParent: updateParent,
                          imageLocation: getImageLocation(),
                          cameraImgOverlay: getOverlayImage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
