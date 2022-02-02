import 'package:flutter/material.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/utils/utils.dart';

Widget getCircleAvatar(
    double width, double height, String name, double fontSize) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.yellow,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
        shape: BoxShape.circle,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.yellow[600], Colors.red]),
      ),
      child: Center(
        child: Text(getInitials(name),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize)),
      ));
}

Widget getLoadingUi() {
  return Container(
    color: Color(0xffEEFAFA),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: Image.asset(get_dress_loader),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Getting Your Cloths . . .",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0, right: 38.0),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            "If waiting makes you Anxious , Stand Up . Go grab some snacks and chill .",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget noProductWidget(BuildContext context,
    {String imagePath, String text, int fractionHeight, bool shrinkWrap}) {
  return ListView(
    shrinkWrap: shrinkWrap ?? true,
    physics: NeverScrollableScrollPhysics(),
    children: <Widget>[
      SizedBox(
          height: MediaQuery.of(context).size.width / (fractionHeight ?? 4)),
      Image.asset(
        imagePath ?? cart,
        scale: 1.5,
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            text ?? "Whoops, No Items in Cart!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
    ],
  );
}
