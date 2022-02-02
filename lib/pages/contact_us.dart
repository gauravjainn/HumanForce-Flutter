import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/utils/home_screen_variables.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/secondary_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.bloc<NavigatorCubit>().changeRoute("Home");
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: SecondaryAppBar(height: 56, title: "Contact Us"),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  margin:
                      EdgeInsets.only(top: 16, bottom: 0, left: 8, right: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: _getUi(context)),
            ],
          ),
        ),
      ),
    );
  }
}

_getUi(BuildContext context) {
  return Container(
    color: Colors.white38,
    child: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Center(child: Image.asset(logo_transparent, width: 200, height: 200)),
        SizedBox(
          height: 30,
        ),
        _buildCardColumn(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Center(child: Text("Verison 1.0.0")),
        Center(child: Text("Made with ❤️ at Blupie Technologies")),
        SizedBox(height: 20),
      ],
    ),
  );
}

Widget _buildCardColumn() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: EdgeInsets.all(12),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        GestureDetector(
            onTap: () async {
              await launch("mailto:$mailId");
            },
            child: _getRowInfo(email_icon, "Email Id", mailId)),
        Divider(
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        GestureDetector(
            onTap: () async {
              await launch("tel://$phone_number");
            },
            child: _getRowInfo(phone_icon, "Phone Number", phone_number)),
        Divider(
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        GestureDetector(
            onTap: () async {
              await launch(location);
            },
            child: _getRowInfo(
                address_icon, "Address ", "1354 Adrash Nagar Udaipur")),
      ],
    ),
  );
}

Widget _getRowInfo(String image, String name, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        width: 10,
      ),
      SvgPicture.asset(
        image,
        width: 25,
        height: 25,
      ),
      SizedBox(
        width: 10,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(color: my_black, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 5,
            ),
            Text(value,
                style:
                    TextStyle(color: my_black, fontWeight: FontWeight.normal))
          ],
        ),
      )
    ],
  );
}
