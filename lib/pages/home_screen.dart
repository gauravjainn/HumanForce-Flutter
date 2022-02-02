import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/home_cubit/home_cubit.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/models/home_model.dart';
import 'package:human_forces/utils/home_screen_variables.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/divider.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.bloc<HomeCubit>().getHomeScreenData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(get_dress_loader), context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: MyDrawer(),
          floatingActionButton: CartFabButton(),
          appBar: MyCustomAppBar(height: 100),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return getLoadingUi();
              }
              if (state is HomeLoaded) {
                return _getListView(state.homeModel);
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  _getListView(HomeModel homeModel) {
    final homeModelEntries = homeModel.data.entries.toList();

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Text("BUY NOW GET 25% OFF",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 22,
                  color: Colors.white)),
          color: light_grey,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: homeModelEntries.length,
              itemBuilder: (BuildContext context, int categoryIndex) {
                final imageList =
                    homeModelEntries[categoryIndex].value["images"];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: gradientDivider(margin: 20)),
                          Text(
                            homeModelEntries[categoryIndex].key,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Expanded(child: gradientDivider(margin: 20)),
                        ],
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Carousel(
                          dotColor: Colors.grey,
                          dotIncreasedColor: Colors.orange,
                          dotBgColor: Colors.transparent,
                          dotIncreaseSize: 1.5,
                          autoplayDuration: Duration(seconds: 5),
                          images: List.generate(imageList.length, (index) {
                            return InkWell(
                              onTap: () {
                                context.bloc<NavigatorCubit>().changeRoute(
                                    homeModelEntries[categoryIndex].key);
                                myRouter.Router.navigator
                                    .pushNamedAndRemoveUntil(
                                        myRouter
                                            .Router.productListWithoutFilter,
                                        (route) =>
                                            route.settings.name ==
                                            myRouter.Router.humanForces,
                                        arguments: homeModelEntries[index].key);
                              },
                              child: Card(
                                  margin: EdgeInsets.all(10),
                                  elevation: 5,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: imageList[index],
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        _buildContactUsCard(),
      ],
    );
  }

  _buildContactUsCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: light_grey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text("Contact Us"),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var item in contactUs) ...{
                        GestureDetector(
                          onTap: item.onTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon, size: 20, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      }
                    ]),
              ),
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () async {
                      await launch(location);
                    },
                    child: Image.asset(
                      gmap,
                    ),
                  ),
                ),
              ),
            ]),
      ]),
    );
  }
}
