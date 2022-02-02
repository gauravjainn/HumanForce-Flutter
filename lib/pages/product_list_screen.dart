import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/product_list_cubit/product_list_cubit.dart';
import 'package:human_forces/models/product_list_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ProductListScreen extends StatefulWidget {
  final ProductListModel productListModel;

  const ProductListScreen({@required this.productListModel});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ProductListModel p;

  int lengthOfTabs = 0;
  bool isTabsNull = false;
  TabController _tabController;

  var decoration = BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.black26],
    ),
  );

  @override
  void initState() {
    super.initState();
    p = widget.productListModel;
    p.details?.categories != null
        ? p.details.categories["All Products"] = null
        : null;
    lengthOfTabs = p.details?.categories?.length ?? 0;

    isTabsNull = lengthOfTabs < 2;

    _tabController = isTabsNull
        ? null
        : TabController(
            initialIndex: lengthOfTabs - 1, length: lengthOfTabs, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final division = lengthOfTabs > 2 ? 3 : lengthOfTabs + 3;
    final padding =
        (MediaQuery.of(context).size.height + 60) / (lengthOfTabs * division);
    return BlocProvider(
        create: (context) =>
            ProductListCubit(productListModel: widget.productListModel),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: MyDrawer(),
            floatingActionButton: CartFabButton(),
            appBar: MyCustomAppBar(height: 100),
            body: Material(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, top: 20, bottom: 20, right: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${p.title}'s Style",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w100)),
                        IconButton(
                          icon: Icon(
                            MdiIcons.filterOutline,
                            size: 26,
                          ),
                          onPressed: () {
                            showFilterBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildProductList(padding),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildProductList(double padding) {
    return BlocBuilder<ProductListCubit, ProductListModel>(
      builder: (context, state) {
        return state.all_products.length > 0 || state.all_products.isNotEmpty
            ? Expanded(
                child: Row(
                  children: [
                    isTabsNull
                        ? Container()
                        : RotatedBox(
                            quarterTurns: 3,
                            child: TabBar(
                              physics: BouncingScrollPhysics(),
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              labelColor: my_black,
                              indicatorPadding: EdgeInsets.all(0.0),
                              indicatorWeight: 2.0,
                              labelPadding: EdgeInsets.all(0.0),
                              indicator: ShapeDecoration(
                                shape: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.transparent,
                                )),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.yellow[600],
                                      Colors.red,
                                    ]),
                              ),
                              tabs: <Widget>[
                                ...List.generate(
                                    p.details.categories.keys.length,
                                    (index) => Container(
                                        padding: EdgeInsets.fromLTRB(
                                            padding, 20, padding, 20),
                                        color: Colors.white,
                                        child: Text(
                                          "${p.details.categories.keys.elementAt(index)}",
                                        )))
                              ],
                              onTap: (index) {
                                context
                                    .bloc<ProductListCubit>()
                                    .emitClothTypeFilter(
                                        state,
                                        state.details.categories.keys
                                            .elementAt(index));
                              },
                            ),
                          ),
                    Expanded(
                      flex: 1,
                      child: state.products.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 28.0, right: 18.0),
                              child: WaterfallFlow.builder(
                                itemCount: (state.products.length) ?? 0,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 30.0,
                                  mainAxisSpacing: 15.0,
                                ),
                                itemBuilder: (context, index) {
                                  ProductModel product = state.products[index];
                                  if (product.image == null) {
                                    return Container();
                                  }
                                  return GestureDetector(
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        Hero(
                                          tag: "$product_list ${product.id}",
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            margin: index % 2 == 0
                                                ? EdgeInsets.only(top: 0)
                                                : EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: CachedNetworkImage(
                                              imageUrl: (product.image ??
                                                  const [""])[0],
                                              placeholder: (context, url) =>
                                                  LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        Text("${product.name}"),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "₹ ${product.price_size} only/-"))
                                      ],
                                    ),
                                    onTap: () {
                                      myRouter.Router.navigator.pushNamed(
                                          myRouter.Router.productDetailScreen,
                                          arguments: ProductSelectorModel(
                                            productModel: product,
                                            selectedSizes: product.batches[0]
                                                ['name'],
                                            selectedColor: product.color[0],
                                            quantity_size: 0,
                                            quantity_batches: 0,
                                            orderType: OrderType.batches,
                                            catergory: p.title,
                                            sub_catergory: p.sub_title,
                                          ));
                                    },
                                  );
                                },
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(24.0),
                              child: noProductWidget(context,
                                  fractionHeight: 6,
                                  shrinkWrap: false,
                                  text:
                                      "Whoops, No Product found for this filter"),
                            ),
                    )
                  ],
                ),
              )
            : noProductWidget(context,
                fractionHeight: 6, text: "Whoops, No Product found !");
      },
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    String selectedColor = "", selectedSubCategory = "";

    _scaffoldKey.currentState.showBottomSheet((context) {
      return BlocBuilder<ProductListCubit, ProductListModel>(
        builder: (context, state) {
          selectedColor = state.colorFilter;
          selectedSubCategory = state.subCategoryFilter;

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.grey[100],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        myRouter.Router.navigator.pop();
                      },
                    ),
                    title: Text("Filters"),
                    trailing: FlatButton.icon(
                      textColor: Colors.blue,
                      icon: Icon(Icons.settings_backup_restore),
                      label: Text("Reset"),
                      onPressed: () {
                        setState(() {
                          selectedColor = "";
                          selectedSubCategory = "";
                        });
                        context
                            .bloc<ProductListCubit>()
                            .emitColorCategoryFilter(
                                productListModel: state,
                                colorFilter: selectedColor,
                                subCategoryFilter: selectedSubCategory);
                        myRouter.Router.navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        state.details.categories != null
                            ? (state.details
                                        .categories[state.clothTypeFilter] !=
                                    null
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Sub Categories",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : Container())
                            : Container(),
                        ...List.generate(
                            state.details.categories != null
                                ? (state.details.categories[
                                            state.clothTypeFilter] !=
                                        null
                                    ? state
                                        .details
                                        .categories[state.clothTypeFilter]
                                        ?.length
                                    : 0)
                                : 0, (index) {
                          return RadioListTile(
                            title: Text(state.details.categories != null
                                ? "${state.details.categories[state.clothTypeFilter][index]}"
                                : ""),
                            value: state.details
                                .categories[state.clothTypeFilter][index],
                            groupValue: selectedSubCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedSubCategory = value;
                              });
                            },
                          );
                        }),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Colors",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ...List.generate(
                            state.details.colors != null
                                ? state.details.colors?.length
                                : 0, (index) {
                          return RadioListTile(
                            title: Text("${state.details?.colors[index]}"),
                            value: state.details.colors[index],
                            groupValue: selectedColor,
                            onChanged: (value) {
                              setState(() {
                                selectedColor = value;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                        disabledColor: Colors.grey,
                        disabledTextColor: my_black,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(18),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            "DONE",
                          ),
                        ),
                        onPressed: () {
                          context
                              .bloc<ProductListCubit>()
                              .emitColorCategoryFilter(
                                  productListModel: state,
                                  colorFilter: selectedColor,
                                  subCategoryFilter: selectedSubCategory);
                          myRouter.Router.navigator.pop(context);
                        }),
                  )
                ],
              ),
            );
          });
        },
      );
    });
  }
}
