import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;

class CheckOutFab extends StatefulWidget {
  @override
  _CheckOutFabState createState() => _CheckOutFabState();
}

class _CheckOutFabState extends State<CheckOutFab> {
  var total = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      if (state is CartItemLoaded) {
        total = 0;
        state.productsList.forEach((e) => total += (int.parse(
                e.orderType == OrderType.batches
                    ? e.price_batches
                    : e.price_size) *
            (e.orderType == OrderType.batches
                ? e.quantity_batches
                : e.quantity_size)));

        return state.productsList.length > 0
            ? FloatingActionButton.extended(
                heroTag: "CHECKOUT",
                onPressed: () {
                  _checkCurrentQuantity(state.productsList).then((value) {
                    if (!value.contains(false)) {
                      myRouter.Router.navigator.pushNamed(
                          myRouter.Router.checkOutScreen,
                          arguments: state.productsList);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Some Items are not available in stock! ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                      );
                    }
                  });
                },
                label: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Checkout (₹ $total.00) → ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
            : Container();
      }
      return Container();
    });
  }

  Future<List<bool>> _checkCurrentQuantity(
      List<ProductModel> productsList) async {
    final Firestore _firestore = Firestore.instance;
    return Future.wait(productsList.map((element) {
      if (element.orderType == OrderType.batches) {
        return _firestore.document(element.dbPath).get().then((value) {
          ProductModel p = ProductModel.fromJson(value.data);
          List<bool> allProducts = p.batches.map((e) {
            if (e['name'] == element.selectedSize) {
              return int.parse(e['quantity'].toString()) >=
                      element.quantity_batches
                  ? true
                  : false;
            }
          }).toList();

          return !allProducts.contains(false);
        });
      } else {
        return _firestore.document(element.dbPath).get().then((value) {
          ProductModel p = ProductModel.fromJson(value.data);
          List<bool> allProducts = p.size.map((e) {
            if (e['name'] == element.selectedSize) {
              return int.parse(e['quantity'].toString()) >=
                      element.quantity_size
                  ? true
                  : false;
            }
          }).toList();
          return !allProducts.contains(false);
        });
      }
    }).toList());

    // return await Future.forEach(
    //     productsList,
    //     (ProductModel element) async => {
    //           if (element.orderType == OrderType.batches)
    //             {
    //               _firestore.document(element.dbPath).get().then((value) {
    //                 ProductModel p = ProductModel.fromJson(value.data);
    //                 p.batches
    //                     .map((e) {
    //                       if (e['name'] == element.selectedSize) {
    //                         return int.parse(e['quantity'].toString()) >=
    //                                 element.quantity_batches
    //                             ? true
    //                             : false;
    //                       }
    //                     })
    //                     .toList()
    //                     .contains(false);
    //               })
    //             }
    //           else
    //             {
    //               _firestore.document(element.dbPath).get().then((value) {
    //                 ProductModel p = ProductModel.fromJson(value.data);
    //                 p.size
    //                     .map((e) {
    //                       if (e['name'] == element.selectedSize) {
    //                         return int.parse(e['quantity'].toString()) >=
    //                                 element.quantity_size
    //                             ? true
    //                             : false;
    //                       }
    //                     })
    //                     .toList()
    //                     .contains(false);
    //               })
    //             }
    //         });
  }
}
