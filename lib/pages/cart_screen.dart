import 'package:cached_network_image/cached_network_image.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/widgets/checkout_fab.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/secondary_app_bar.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> _isSelected = [false, false];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CheckOutFab(),
        backgroundColor: Colors.black,
        appBar: SecondaryAppBar(
          title: "Cart",
          height: 56,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 16, bottom: 0, left: 8, right: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state is CartItemLoaded) {
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: state.productsList.length > 0
                              ? Text(
                                  "Cart (${state.productsList.length} items)",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w100))
                              : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: state.productsList.length > 0
                              ? ListView.builder(
                                  itemCount: state.productsList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return _buildListItem(
                                        state.productsList[index], index);
                                  })
                              : noProductWidget(context),
                        ),
                        SizedBox(height: 50),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListItem(ProductModel product, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.fromLTRB(0, 5, 7, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Container(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(right: 8, left: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: product.image[0],
                  fit: BoxFit.fill,
                  placeholder: (context, url) => LinearProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.name}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(int.parse(
                                  "0xff${product.selectedColor['color']}") ??
                              Colors.black),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        "${product.selectedSize}",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        product.orderType == OrderType.batches
                            ? "Quantity: ${product.quantity_batches}"
                            : "Quantity: ${product.quantity_size}",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    product.orderType == OrderType.batches
                        ? "₹ ${product.price_batches}"
                        : "₹ ${product.price_size}",
                    style: TextStyle(color: Colors.blue)),
                Text("Min. Quantity: ${product.min_quantity}",
                    style: TextStyle(color: Colors.blue)),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.bloc<CartCubit>().removeAllItemQuantity(
                            product,
                          );
                    },
                    child: Center(
                      child: Text(
                        "Remove Item",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 8),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(4),
          //     border: Border.all(color: Colors.green),
          //   ),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       GestureDetector(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(3),
          //               topRight: Radius.circular(3),
          //             ),
          //             color: Colors.green,
          //           ),
          //           clipBehavior: Clip.antiAlias,
          //           child: Icon(Icons.add, size: 18, color: Colors.white),
          //         ),
          //         onTap: () {
          //           product.orderType == OrderType.batches
          //               ? context.bloc<CartCubit>().addItem(
          //                   product,
          //                   1,
          //                   0,
          //                   product.selectedColor,
          //                   product.selectedSize,
          //                   product.orderType,
          //                   index: index)
          //               : context.bloc<CartCubit>().addItem(
          //                   product,
          //                   0,
          //                   1,
          //                   product.selectedColor,
          //                   product.selectedSize,
          //                   product.orderType,
          //                   index: index);
          //         },
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          //         child: Text(
          //             product.orderType == OrderType.batches
          //                 ? "${product.quantity_batches}"
          //                 : "${product.quantity_size}",
          //             style: TextStyle(
          //               color: Colors.green,
          //             )),
          //       ),
          //       GestureDetector(
          //         child: Container(
          //           clipBehavior: Clip.antiAlias,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(3),
          //               bottomRight: Radius.circular(3),
          //             ),
          //             color: Colors.green,
          //           ),
          //           child: Icon(Icons.remove, size: 18, color: Colors.white),
          //         ),
          //         onTap: () {
          //           context.bloc<CartCubit>().removeItem(product, index);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSuggestedItem(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.fromLTRB(8, 10, 16, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width / 1.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: "https://picsum.photos/70/120",
                  fit: BoxFit.fill,
                  placeholder: (context, url) => SizedBox(
                    child: LinearProgressIndicator(),
                    width: 20,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Zara Jeans",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "by Zara",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("₹ 799", style: TextStyle(color: Colors.blue))),
                  FlatButton(
                    minWidth: double.infinity,
                    child: Text("Add"),
                    shape: OutlineInputBorder(),
                    onPressed: () {
                      _buildBottomSheet(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 40, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Select Size")),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomToggleButtons(
                      isSelected: _isSelected,
                      selectedBorderColor: Colors.blue,
                      onPressed: (index) {
                        setState(() {
                          _isSelected = _isSelected.asMap().entries.map((e) {
                            if (index == e.key) return true;
                            return false;
                          }).toList();
                        });
                      },
                      spacing: 5,
                      children: [
                        Text("XS"),
                        Text("S"),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Select Color")),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomToggleButtons(
                      spacing: 5,
                      isSelected: _isSelected,
                      selectedBorderColor: Colors.blue,
                      onPressed: (index) {
                        setState(() {
                          _isSelected = _isSelected.asMap().entries.map((e) {
                            if (index == e.key) return true;
                            return false;
                          }).toList();
                        });
                      },
                      children: [
                        Container(color: Colors.blue, width: 40, height: 40),
                        Container(color: Colors.green, width: 40, height: 40),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton.extended(
                      heroTag: "ADDTOCART",
                      label: Text(
                        "Add To Cart",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        myRouter.Router.navigator.pop(context);
                      },
                      icon: Icon(Icons.add_shopping_cart_rounded)),
                  SizedBox(height: 10),
                ],
              ));
        });
      },
      backgroundColor: Colors.white,
    );
  }
}
