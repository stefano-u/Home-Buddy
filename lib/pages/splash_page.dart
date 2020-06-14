import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splash';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _navigateToHomePage() {
    Navigator.popAndPushNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF7FB2B1),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    kAppName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(
                      fontSize: 48,
                      color: Color(0xFFFFDC66)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
                    child: Text(
                      'Finding fun wherever you are',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.white,
                        height: 1
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 25),
                      child: Image.asset('assets/btn_enter.png', ),
                    ),
                    onPressed: _navigateToHomePage,
                    highlightColor: Colors.transparent,
                  ),

                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/sloth.png',scale: 4,),
            ),
          ],
        ),
      ),
    );
  }
}
