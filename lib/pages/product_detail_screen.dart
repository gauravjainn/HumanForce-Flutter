import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/cubits/product_cubit/product_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/repositories/product_repository.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/color_dots.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/secondary_app_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductSelectorModel productSelectorModel;
  const ProductDetailScreen(this.productSelectorModel);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(
        context.repository<ProductRepository>(),
        productSelectorModel: widget.productSelectorModel,
      ),
      lazy: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: SecondaryAppBar(
            title: "Product Detail",
            height: 56,
            isLeading: true,
          ),
          body: StreamBuilder(
              stream: context
                  .repository<ProductRepository>()
                  .getProductDetailAsStream(widget.productSelectorModel),
              builder: (context, AsyncSnapshot<ProductModel> snapshot) {
                if (snapshot.hasData) {
                  return _body(snapshot.data);
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Widget _body(ProductModel product) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top: 16, bottom: 0, left: 8, right: 8),
                padding: EdgeInsets.only(left: 16, right: 20, top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _productTitleWithImage(product: product),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: _buildPrice(product),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _description(product: product),
                    SizedBox(height: kDefaultPaddin * 5),
                    _colorAndSize(product: product),
                    SizedBox(height: kDefaultPaddin * 5),
                    _buildQunatity(product: product),
                    SizedBox(height: kDefaultPaddin * 5),
                    _addToCart(product),
                    SizedBox(height: kDefaultPaddin * 5),
                    Text(
                      "Product Reviews : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: kDefaultPaddin * 5),
                    _buildReview(product),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildReview(ProductModel product) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0;
            index <
                ((product.reviews?.length ?? 0) > 0
                    ? product.reviews?.length
                    : 0);
            index++) ...{
          // Text("hello"),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.black45,
                    style: BorderStyle.solid,
                    width: 0.80),
              ),
              child: ListTile(
                leading: getCircleAvatar(
                    40, 40, "${product.reviews[index]['name']}", 12),
                title: Text(
                  "${product.reviews[index]['name']}",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  "${product.reviews[index]['text']}",
                  maxLines: 8,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          // Card(
          //   elevation: 4,
          //   clipBehavior: Clip.antiAlias,
          //   child: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(5),
          //         border: Border.all(
          //             color: Colors.black45,
          //             style: BorderStyle.solid,
          //             width: 0.80),
          //       ),
          //       padding: EdgeInsets.all(3),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: getCircleAvatar(30, 30,
          //                 "${product.reviews[index]['name']}" ?? "", 12),
          //           ),
          //           Column(
          //             mainAxisSize: MainAxisSize.min,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "${product.reviews[index]['name']}",
          //                 style: TextStyle(
          //                   letterSpacing: 1,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 12,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 5,
          //               ),
          //               Text(
          //                 "${product.reviews[index]['text']}",
          //                 maxLines: 8,
          //                 textAlign: TextAlign.justify,
          //                 overflow: TextOverflow.visible,
          //                 softWrap: true,
          //                 style: TextStyle(
          //                   letterSpacing: 1,
          //                   fontSize: 10,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       )),
          // ),
        },
      ],
    );
  }

  Widget _buildPrice(ProductModel productModel) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      return Text(
          state.productSelectorModel.orderType == OrderType.batches
              ? "₹ ${productModel.price_batches}"
              : "₹ ${productModel.price_size}",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold));
    });
  }

  Widget _buildQunatity({ProductModel product}) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        List<bool> _isSelected = List.filled(OrderType.values.length, false);
        _isSelected[state.productSelectorModel.orderType.index] = true;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: CustomToggleButtons(
                    isSelected: _isSelected,
                    borderRadius: 80,
                    borderWidth: 2,
                    selectedBorderColor: Colors.blue,
                    onPressed: (index) {
                      context.bloc<ProductCubit>().changeOrderType(
                          state, state.productSelectorModel, index);
                    },
                    spacing: 10,
                    children: [
                      Text(
                        "Batch",
                        style: TextStyle(fontSize: 16, letterSpacing: 1),
                      ),
                      Text(
                        "Size",
                        style: TextStyle(fontSize: 16, letterSpacing: 1),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQunatitySelector(
                      state, state.productSelectorModel, context, product),
                  _cartCounter(state, state.productSelectorModel, context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQunatitySelector(
      ProductState state,
      ProductSelectorModel productSelectorModel,
      BuildContext context,
      ProductModel productModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: Colors.blue, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButton<String>(
        underline: Container(),
        value: (productSelectorModel.orderType == OrderType.batches
            ? productModel.batches.firstWhere((value) {
                      return (value['name'] ==
                          productSelectorModel.selectedSizes);
                    })['name'] ==
                    productSelectorModel.selectedSizes
                ? productSelectorModel.selectedSizes
                : productModel.batches[0]['name']
            : productModel.size.firstWhere((value) {
                      return (value['name'] ==
                          productSelectorModel.selectedSizes);
                    })['name'] ==
                    productSelectorModel.selectedSizes
                ? productSelectorModel.selectedSizes
                : productModel.size[0]['name']),
        items: List.generate(
            productSelectorModel.orderType == OrderType.batches
                ? productModel.batches.length
                : productModel.size.length,
            (index) => DropdownMenuItem(
                value: productSelectorModel.orderType == OrderType.batches
                    ? productModel.batches[index]['name']
                    : productModel.size[index]['name'],
                child: Text.rich(TextSpan(
                    text: productSelectorModel.orderType == OrderType.batches
                        ? "${productModel.batches[index]['name']}"
                        : "${productModel.size[index]['name']}",
                    children: [
                      TextSpan(
                        text: productSelectorModel.orderType ==
                                OrderType.batches
                            ? "\n(available : ${productModel.batches[index]['quantity']})"
                            : "\n(Available : ${productModel.size[index]['quantity']})",
                        style: TextStyle(fontSize: 12),
                      ),
                    ])))),
        onChanged: (value) {
          context
              .bloc<ProductCubit>()
              .changeSelectedSizes(state, productSelectorModel, value);
        },
      ),
    );
  }

  Widget _productTitleWithImage({ProductModel product}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Hero(
        tag: "$product_list ${product.id}",
        child: Carousel(
          dotColor: Colors.grey,
          dotIncreasedColor: Colors.orange,
          dotBgColor: Colors.transparent,
          dotIncreaseSize: 1.5,
          autoplayDuration: Duration(seconds: 5),
          images: List.generate(product.image.length, (index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: product.image[index],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => LinearProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
            );
          }),
        ),
      ),
    );
  }

  Widget _description({ProductModel product}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "${product.description}",
        style: TextStyle(height: 1.5, color: Colors.grey, fontSize: 12),
      ),
    );
  }

  Widget _colorAndSize({ProductModel product}) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Min. Quantity: ${product.min_quantity}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Colors :",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Row(
                      children: <Widget>[
                        ...List.generate(product.color.length, (index) {
                          return GestureDetector(
                            child: ColorDot(
                              color: Color(int.parse(
                                  "0xff${product.color[index]['color']}")),
                              isSelected: product.color[index]['color'] ==
                                      (state.productSelectorModel
                                              .selectedColor['color'] ??
                                          "")
                                  ? true
                                  : false,
                            ),
                            onTap: () {
                              context.bloc<ProductCubit>().changeSelectedColor(
                                  state,
                                  state.productSelectorModel,
                                  product.color[index]);
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "Type :\n"),
                      TextSpan(
                        text: "${product.category} (${product.sub_category})",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cartCounter(ProductState state,
      ProductSelectorModel productSelectorModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Text("Quantity:"),
        // SizedBox(height: 10),
        Row(
          children: <Widget>[
            buildOutlineButton(
              icon: Icons.remove,
              press: () {
                productSelectorModel.orderType == OrderType.batches
                    ? context.bloc<ProductCubit>().changeQuantity(
                        state, productSelectorModel,
                        quantity_batches:
                            productSelectorModel.quantity_batches - 1)
                    : context.bloc<ProductCubit>().changeQuantity(
                        state, productSelectorModel,
                        quantity_size: productSelectorModel.quantity_size - 1);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8 / 2),
              child: Text(
                productSelectorModel.orderType == OrderType.batches
                    ? productSelectorModel.quantity_batches
                        .toString()
                        .padLeft(2, "0")
                    : productSelectorModel.quantity_size
                        .toString()
                        .padLeft(2, "0"),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            buildOutlineButton(
                icon: Icons.add,
                press: () {
                  productSelectorModel.orderType == OrderType.batches
                      ? context.bloc<ProductCubit>().changeQuantity(
                          state, productSelectorModel,
                          quantity_batches:
                              productSelectorModel.quantity_batches + 1)
                      : context.bloc<ProductCubit>().changeQuantity(
                          state, productSelectorModel,
                          quantity_size:
                              productSelectorModel.quantity_size + 1);
                }),
          ],
        ),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 30,
      height: 24,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  Widget _addToCart(ProductModel productModel) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              if (state is AddToCartAdded) ...{
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      color: Colors.black,
                      onPressed: () async {
                        context.bloc<ProductCubit>().emitAddMoreItem();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Add More".toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              },
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FlatButton(
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: Colors.black,
                    onPressed: state is AddToCartAdded
                        ? null
                        : () async {
                            if (state.productSelectorModel.orderType ==
                                OrderType.batches) {
                              if (state.productSelectorModel.quantity_batches >=
                                  (productModel.min_quantity ?? 0)) {
                                if (_checkMaxQuantity(
                                    productModel,
                                    OrderType.batches,
                                    state.productSelectorModel.selectedSizes,
                                    state.productSelectorModel.quantity_batches,
                                    state.productSelectorModel.quantity_size)) {
                                  context.bloc<CartCubit>().addItem(
                                      productModel,
                                      state.productSelectorModel
                                          .quantity_batches,
                                      0,
                                      state.productSelectorModel.selectedColor,
                                      state.productSelectorModel.selectedSizes,
                                      state.productSelectorModel.orderType);

                                  context.bloc<ProductCubit>().emitItemAdded();
                                  Fluttertoast.showToast(
                                    msg: "Item Added to Cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Order quantity is not available in stock",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      "Order quantity cannot less than ${productModel.min_quantity}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            } else {
                              if (state.productSelectorModel.quantity_size >=
                                  (productModel.min_quantity ?? 0)) {
                                if (_checkMaxQuantity(
                                    productModel,
                                    OrderType.size,
                                    state.productSelectorModel.selectedSizes,
                                    state.productSelectorModel.quantity_batches,
                                    state.productSelectorModel.quantity_size)) {
                                  context.bloc<CartCubit>().addItem(
                                      productModel,
                                      0,
                                      state.productSelectorModel.quantity_size,
                                      state.productSelectorModel.selectedColor,
                                      state.productSelectorModel.selectedSizes,
                                      state.productSelectorModel.orderType);

                                  context.bloc<ProductCubit>().emitItemAdded();
                                  Fluttertoast.showToast(
                                    msg: "Item Added to Cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Order quantity is not available in stock",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      "Order quantity cannot less than ${productModel.min_quantity}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state is AddToCartAdded
                              ? Icons.check
                              : Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        state is AddToCartAdded
                            ? Text(
                                "Item added".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Add to Cart".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _checkMaxQuantity(
    ProductModel p,
    OrderType orderType,
    dynamic selectedSizes,
    int quantity_batches,
    int quantity_size,
  ) {
    if (orderType == OrderType.batches) {
      int index = p.batches.indexWhere((e) {
        return e['name'] == selectedSizes;
      });
      print(int.parse(p.batches[index]['quantity'].toString()));
      print(quantity_batches);
      return int.parse(p.batches[index]['quantity'].toString()) >=
              quantity_batches
          ? true
          : false;
    } else {
      int index = p.size.indexWhere((e) => e['name'] == selectedSizes);
      return int.parse(p.size[index]['quantity'].toString()) >= quantity_size
          ? true
          : false;
    }
  }
}
