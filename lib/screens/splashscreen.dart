import 'package:mahakfaheem_mdp_crud_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakfaheem_mdp_crud_app/screens/second_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      duration: 10000-1500,
      imageSize: 100,

      imageSrc: 'assets/cake1.png',
      text: "\n Birthday Lookup \n\n\n MDP ASSIGNMENT \n\n\n ",


      textStyle: TextStyle(color: Colors.yellowAccent, fontSize: 30,fontWeight: FontWeight.bold,),
      //navigateRoute: HomeScreen(),
      navigateRoute: SecondScreen(),
      //navigateRoute: SignInScreen(),
      backgroundColor: CupertinoDynamicColor.withBrightness(color: Colors.pinkAccent, darkColor: Colors.black87),
      textType: TextType.TyperAnimatedText,
    );
  }
}
