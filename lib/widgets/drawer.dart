import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/models/drawer_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/drawer_variables.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/divider.dart';
import 'package:human_forces/widgets/gradient_shader.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topRight: Radius.circular(20))),
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          children: [
            BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              if (state is UserLoggedIn) {
                return InkWell(
                  onTap: () {
                    myRouter.Router.navigator
                        .pushNamed(myRouter.Router.profileScreen);
                  },
                  child: Container(
                    color: light_grey,
                    height: 60,
                    padding: EdgeInsets.all(3),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              state.userModel.shop_name,
                              style: TextStyle(
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getCircleAvatar(
                              50, 50, state.userModel.shop_name ?? "", 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            }),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: drawerItems.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildDrawerList(drawerItems[index], context,
                        isExpanded: true),
                physics: BouncingScrollPhysics(),
              ),
            ),
            gradientDivider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                onTap: () {
                  myRouter.Router.navigator.pop();
                  context.bloc<NavigatorCubit>().changeRoute("Home");
                  myRouter.Router.navigator.pushNamedAndRemoveUntil(
                      myRouter.Router.contactUsScreen,
                      (route) =>
                          route.settings.name == myRouter.Router.humanForces);
                },
                leading: SvgPicture.asset(
                  contact_svg,
                  width: 22,
                  height: 22,
                ),
                title: Text(
                  "Contact Us",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                onTap: () {
                  myRouter.Router.navigator.pop();
                  context.bloc<NavigatorCubit>().changeRoute("Home");
                  myRouter.Router.navigator.pushNamedAndRemoveUntil(
                      myRouter.Router.aboutUsScreen,
                      (route) =>
                          route.settings.name == myRouter.Router.humanForces);
                },
                leading: SvgPicture.asset(
                  about_us_svg,
                  width: 22,
                  height: 22,
                ),
                title: Text(
                  "About Us",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerList(DrawerModel root, BuildContext context,
      {bool isExpanded = false}) {
    return BlocBuilder<NavigatorCubit, String>(
      builder: (context, route) {
        return Padding(
          padding: EdgeInsets.only(left: 10),
          child: root.subItems.isEmpty
              ? InkWell(
                  child: ListTile(
                    leading: root.name == route
                        ? GradientShader(
                            child: SvgPicture.asset(
                              root.image,
                              width: 22,
                              height: 22,
                              color: Colors.yellow[600],
                            ),
                            gradient: RadialGradient(
                              center: Alignment.bottomLeft,
                              radius: 0.5,
                              colors: [Colors.yellow[600], Colors.red],
                              tileMode: TileMode.mirror,
                            ),
                          )
                        : SvgPicture.asset(
                            root.image,
                            width: 22,
                            height: 22,
                          ),
                    title: Align(
                      alignment: Alignment(-1, 0),
                      child: root.name == route
                          ? GradientShader(
                              child: Text(
                                root.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.yellow[600], Colors.red]),
                            )
                          : Text(
                              root.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                  onTap: () {
                    myRouter.Router.navigator.pop();
                    context.bloc<NavigatorCubit>().changeRoute(root.name);
                    myRouter.Router.navigator.pushNamedAndRemoveUntil(
                        root.route,
                        (route) =>
                            route.settings.name == myRouter.Router.humanForces,
                        arguments: root.name);
                  },
                )
              : ExpansionTile(
                  maintainState: true,
                  childrenPadding: EdgeInsets.only(left: 12),
                  initiallyExpanded: isExpanded,
                  leading: SvgPicture.asset(
                    root.image,
                    width: 22,
                    height: 22,
                  ),
                  children: root.subItems
                      .map((i) => _buildDrawerList(i, context))
                      .toList(),
                  title: Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      root.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
