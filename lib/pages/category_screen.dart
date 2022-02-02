import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/category_cubit/category_cubit.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;

import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({@required this.category});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String category;
  @override
  void initState() {
    super.initState();
    context.bloc<CategoryCubit>().getCategoryData(widget.category);
    category = context.bloc<NavigatorCubit>().getCurrentScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.bloc<CategoryCubit>().getCategoryData(widget.category);
    category = context.bloc<NavigatorCubit>().getCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (category != "Kids") {
          context.bloc<NavigatorCubit>().changeRoute("Home");
        }
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          drawer: MyDrawer(),
          floatingActionButton: CartFabButton(),
          appBar: MyCustomAppBar(height: 100),
          body: BlocConsumer<CategoryCubit, CategoryState>(
            listener: (context, state) {
              if (state is CategoryProductLoaded) {
                myRouter.Router.navigator.pop(context);
                myRouter.Router.navigator.pushNamed(
                    myRouter.Router.productListScreen,
                    arguments: state.productListModel);
              }
            },
            buildWhen: (prev, next) {
              return next is! CategoryProductLoading &&
                  next is! CategoryProductLoaded;
            },
            builder: (context, state) {
              print("category screen ui is " + state.toString());
              if (state is CategoryLoaded) {
                return _getUi(state);
              }
              return getLoadingUi();
            },
          ),
        ),
      ),
    );
  }

  _getUi(CategoryLoaded state) {
    return state.categoryList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: WaterfallFlow.builder(
                itemCount: state.categoryList.length,
                physics: BouncingScrollPhysics(),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 15.0,
                ),
                itemBuilder: (context, index) {
                  int random = Random().nextInt(10) + 1;
                  return InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => Dialog(
                                  child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 24),
                                    Text("Please Wait"),
                                  ],
                                ),
                              )));
                      context.bloc<CategoryCubit>().getProductListData(
                          category, state.categoryList[index]);
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
                            child: Text(
                              "${state.categoryList[index]}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        : noProductWidget(context, text: "Whoops, No Item Available !");
  }

  Widget _getCategoryUi(CategoryLoaded state) {
    return ListView.builder(
        itemCount: state.categoryList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(state.categoryList[index]),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                          child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 24),
                            Text("Please Wait"),
                          ],
                        ),
                      )));
              context
                  .bloc<CategoryCubit>()
                  .getProductListData(category, state.categoryList[index]);
            },
          );
        });
  }
}
