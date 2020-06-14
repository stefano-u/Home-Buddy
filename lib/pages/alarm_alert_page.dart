import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:oscilloscope/oscilloscope.dart';

import '../constants.dart';

class AlarmAlertPage extends StatefulWidget {
  static const String id = 'alarm_alert';
  @override
  _AlarmAlertPageState createState() => _AlarmAlertPageState();
}

class _AlarmAlertPageState extends State<AlarmAlertPage> {
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = NoiseMeter();
  bool _isHearAlarm = false;
  FlutterTtsImproved flutterTts = FlutterTtsImproved();
  var ttsState;
  List<double> volumeList;
  Oscilloscope volumeWave;

  // Initializes the camera on widget load
  @override
  void initState() {
    super.initState();
    startListeningAudio();
    flutterTts.setVolume(0.2);
    volumeList = [];
    // Create A Scope Display for Sine

  }

  Widget generateQuestionPrompt() {
    if (_isHearAlarm) {
      return Text('I hear an alarm!',
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 24,
          ));
    } else {
      return Text('I don\'t hear any alarms.',
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 24,
          ));
    }
  }

  void _speak() async {
    await flutterTts.speak("Stop!");
  }

  void startListeningAudio() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onAudioData);
    } catch (exception) {
      print(exception);
    }
  }

  void onAudioData(NoiseReading noiseReading) {
    setState(() {
      var decibel = noiseReading.maxDecibel;
      if (decibel > 80) {
        decibel+=30;
        this._isHearAlarm = true;
        _speak();
      } else {
        this._isHearAlarm = false;
      }

      volumeList.add(noiseReading.maxDecibel);
    });
  }

  void stopAudioRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void _stopTTS() async {
    await flutterTts.stop();
  }

  Widget generateSlothImage() {
    String assetLocation = '';
    if (_isHearAlarm) {
      assetLocation = 'assets/sloth_shocked.png';
    } else {
      assetLocation = 'assets/sloth.png';
    }
    return Image.asset(
      assetLocation,
      scale: 4,
    );
  }

  @override
  void dispose() {
    super.dispose();
    stopAudioRecorder();
    _stopTTS();
  }

  @override
  Widget build(BuildContext context) {
    volumeWave = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.orange,
      backgroundColor: Colors.transparent,
      traceColor: Color(0xFF58871D),
      yAxisMax: 100,
      yAxisMin: 30,
      dataSet: volumeList,
    );

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
        body: Padding(
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
                SizedBox(height: 10),
                Flexible(
                  child: generateQuestionPrompt(),
                ),
                SizedBox(height: 30),
                Expanded(child: volumeWave),
                SizedBox(height: 30,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF58871D)),
                    color: Color(0xFF58871D),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      generateSlothImage(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
//                              onBottomButtonPressed(context);
                      },
                      child: Image.asset(
                        'assets/stop_audio.png',
                        scale: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
