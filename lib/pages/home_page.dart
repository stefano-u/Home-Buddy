import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileremote/components/data_storage.dart';
import 'package:mobileremote/pages/show_me_game_page.dart';

import '../constants.dart';
import 'alarm_alert_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDataContainerState _dataContainer;

  void _navigateToShowMeGamePage() {
    Navigator.pushNamed(context, ShowMeGamePage.id);
  }

  void _navigateToAlarmAlertPage() {
    Navigator.pushNamed(context, AlarmAlertPage.id);
  }

  @override
  Widget build(BuildContext context) {
    _dataContainer = UserDataContainer.of(context);
    _dataContainer.isCorrect = false;
    _dataContainer.isAnswered = false;

    double fontSize = 15;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF7FB2B1),
        appBar: AppBar(
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
        body: Stack(
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
                    Flexible(
                      child: Text(
                        'Hey Ava!\nLet\'s have some fun at home today!',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  _navigateToShowMeGamePage(),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Color(0xFFDCE140),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Image.asset(
                                  'assets/show_me.png',
                                  scale: 5,
                                ),
                              ),
                            ),
                            Text(
                              'Show Me',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                fontSize: fontSize,
                                color: Color(0xFF464746),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  _navigateToAlarmAlertPage(),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Color(0xFF58871D),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Image.asset(
                                  'assets/alarm_alert.png',
                                  scale: 5,
                                ),
                              ),
                            ),
                            Text(
                              'Alarm Alert',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                fontSize: fontSize,
                                color: Color(0xFF464746),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  _navigateToShowMeGamePage(),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Color(0xFFFFDC66),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Image.asset(
                                  'assets/tastes_like.png',
                                  scale: 5,
                                ),
                              ),
                            ),
                            Text(
                              'Tastes Like',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                fontSize: fontSize,
                                color: Color(0xFF464746),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  _navigateToAlarmAlertPage(),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Color(0xFFBCE4E2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Image.asset(
                                  'assets/bath_time.png',
                                  scale: 5,
                                ),
                              ),
                            ),
                            Text(
                              'Bath Time',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                fontSize: fontSize,
                                color: Color(0xFF464746),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/sloth_thinking.png',
                scale: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
