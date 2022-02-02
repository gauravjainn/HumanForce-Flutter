import 'package:flutter/material.dart';
import 'package:human_forces/pages/human_forces.dart';
import 'package:human_forces/utils/strings.dart';

import 'routes/router.gr.dart' as myRouter;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        accentColor: my_black,
        primaryColor: my_black,
        primaryColorDark: my_black,
        inputDecorationTheme: InputDecorationTheme(
            border:
                UnderlineInputBorder(borderSide: BorderSide(color: my_black)),
            labelStyle: TextStyle(decorationColor: Colors.grey[100]),
            fillColor: my_black),
      ),
      onGenerateRoute: myRouter.Router.onGenerateRoute,
      navigatorKey: myRouter.Router.navigatorKey,
      home: Scaffold(
        body: HumanForces(),
      ),
    );
  }
}
