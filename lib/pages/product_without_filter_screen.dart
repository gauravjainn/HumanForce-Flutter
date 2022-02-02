import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/cubits/product_list_without_filter_cubit/product_list_without_filter_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ProductListWithoutFilter extends StatefulWidget {
  final String sectionTitle;

  const ProductListWithoutFilter(this.sectionTitle);
  @override
  _ProductListWithoutFilterState createState() =>
      _ProductListWithoutFilterState();
}

class _ProductListWithoutFilterState extends State<ProductListWithoutFilter> {
  @override
  void initState() {
    super.initState();
    context
        .bloc<ProductListWithoutFilterCubit>()
        .getProductListForSection(widget.sectionTitle);
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
          body: _buildProductList(),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductListWithoutFilterCubit, List<ProductModel>>(
      builder: (context, state) {
        return state.length > 0 && state.isNotEmpty && state.first.name != null
            ? Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 18.0),
                child: WaterfallFlow.builder(
                  itemCount: (state.length) ?? 0,
                  physics: BouncingScrollPhysics(),
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemBuilder: (context, index) {
                    ProductModel product = state[index];

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
                                  borderRadius: BorderRadius.circular(20)),
                              child: CachedNetworkImage(
                                imageUrl: (product.image ?? const [""])[0],
                                placeholder: (context, url) =>
                                    LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Text("${product.name}"),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("₹ ${product.price_size} only/-"))
                        ],
                      ),
                      onTap: () {
                        myRouter.Router.navigator
                            .pushNamed(myRouter.Router.productDetailScreen,
                                arguments: ProductSelectorModel(
                                  productModel: product,
                                  selectedSizes: product.batches[0],
                                  selectedColor: product.color[0],
                                  quantity_size: 0,
                                  quantity_batches: 0,
                                  orderType: OrderType.batches,
                                  catergory: widget.sectionTitle,
                                  sub_catergory: "",
                                ));
                      },
                    );
                  },
                ),
              )
            : noProductWidget(context, text: "Whoops, No Item Available !");
      },
    );
  }
}
