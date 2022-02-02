import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class PreLoadCategoryScreen extends StatefulWidget {
  final String category;

  const PreLoadCategoryScreen({@required this.category});
  @override
  _PreLoadCategoryScreenState createState() => _PreLoadCategoryScreenState();
}

class _PreLoadCategoryScreenState extends State<PreLoadCategoryScreen> {
  List<String> categoryList = ["Boys", "Girls"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.bloc<NavigatorCubit>().changeRoute("Home");
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          drawer: MyDrawer(),
          floatingActionButton: CartFabButton(),
          appBar: MyCustomAppBar(height: 100),
          body: _getUi(),
        ),
      ),
    );
  }

  _getUi() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: WaterfallFlow.builder(
          itemCount: 2,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 15.0,
          ),
          itemBuilder: (context, index) {
            int random = Random().nextInt(10) + 1;
            return InkWell(
              onTap: () {
                myRouter.Router.navigator.pushNamedAndRemoveUntil(
                    myRouter.Router.categoryScreen,
                    (route) =>
                        route.settings.name ==
                        myRouter.Router.preLoadCategoryScreen,
                    arguments: "Kid ${categoryList[index]}");
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/random/$random.jpg"),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.babyFaceOutline,
                              size: 32, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            "${categoryList[index]}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
