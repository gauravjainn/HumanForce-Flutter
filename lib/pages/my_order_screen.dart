import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:human_forces/cubits/my_order_cubit/my_orders_cubit.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/models/order_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/home_screen_variables.dart';
import 'package:human_forces/widgets/app_bar.dart';
import 'package:human_forces/widgets/cart_fab_button.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  String sellerId = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    UserState userState = context.bloc<UserCubit>().state;
    if (userState is UserLoggedIn) {
      sellerId = userState.userModel.sellerId;
      context.bloc<MyOrdersCubit>().getMyOrders(userState.userModel.sellerId);
    }
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
          key: _scaffoldKey,
          drawer: MyDrawer(),
          floatingActionButton: CartFabButton(),
          appBar: MyCustomAppBar(height: 100),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () {
              context.bloc<MyOrdersCubit>().getMyOrders(sellerId);
              return Future.delayed(
                Duration(seconds: 2),
              );
            },
            child: BlocConsumer<MyOrdersCubit, List<OrderModel>>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.length > 0 || state.isNotEmpty
                    ? ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 20, bottom: 20, right: 15),
                              child: Text("Recent Orders",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w100)),
                            ),
                          ),
                          ListView.builder(
                              itemCount: state.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _buildOrder(state[index]);
                              }),
                        ],
                      )
                    : noProductWidget(context,
                        fractionHeight: 6, text: "Whoops, No Orders found !");
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrder(OrderModel orderModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          Container(
            color: Colors.blue[50],
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "ORDER NO : ${orderModel.transaction_id.substring(0, 10)}"),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_getFormatDate(orderModel.order_date))),
                    Row(
                      children: [
                        Text("ITEM :   ${orderModel.products.length}"),
                        SizedBox(width: 15),
                        Text("TOTAL :   ₹ ${orderModel.total_amount}.00"),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getColor(orderModel.status)),
                  ),
                  child: Text(
                    "${orderModel.status}",
                    style: TextStyle(
                      color: _getColor(orderModel.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: orderModel.products.length,
            itemBuilder: (context, index) => _buildSingleItem(
              orderModel,
              orderModel.products[index],
              index,
            ),
          ),
          GestureDetector(
            onTap: () {
              launch("tel://$phone_number");
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(_getAction(orderModel.status)),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getAction(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return "CANCEL ORDER";
        break;
      case "PROCESSING":
        return "CANCEL ORDER";
        break;
      case "DISPATCHED":
        return "CANCEL ORDER";
        break;
      case "DELIVERED":
        return "RETURN ORDER";
        break;
      case "NOT DELIEVERD":
        return "CANCEL ORDER";
        break;
      default:
        return "CANCEL ORDER";
    }
  }

  _getColor(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Colors.yellow[800];
        break;
      case "PROCESSING":
        return Colors.blue;
        break;
      case "DISPATCHED":
        return Colors.blue;
        break;
      case "DELIVERED":
        return Colors.green;
        break;
      case "NOT DELIEVERD":
        return Colors.red;
        break;
      default:
        return Colors.black;
    }
  }

  _getFormatDate(String date) {
    final format = DateFormat.yMd().parse(date);
    return "${DateFormat.EEEE().format(format)} ${DateFormat.yMMMMd().format(format)}";
  }

  _buildSingleItem(OrderModel orderModel, ProductModel product, int index) {
    return GestureDetector(
      onTap: orderModel.status == "DELIVERED"
          ? () {
              showMessageForRating(context, orderModel, index, product.review);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: product.image[0],
                      fit: BoxFit.fill,
                      placeholder: (context, url) => LinearProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${product.name} ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
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
                                    ? "Quantity : ${product.quantity_batches}"
                                    : "Quantity : ${product.quantity_size}",
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Color(int.parse(
                                          "0xff${product.selectedColor['color']}") ??
                                      Colors.black),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                    product.orderType == OrderType.batches
                        ? "₹ ${product.price_batches}"
                        : "₹ ${product.price_size}",
                    style: TextStyle(color: Colors.blue)),
                Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showMessageForRating(
    BuildContext context,
    OrderModel orderModel,
    int index,
    String review,
  ) {
    bool isLoading = false;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 18, top: 18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18))),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 18),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Product Review",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Product : ${orderModel.products[index].name}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Card(
                                elevation: 4,
                                margin: EdgeInsets.fromLTRB(0, 5, 5, 8),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: TextFormField(
                                  initialValue: review,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 5,
                                  onChanged: (value) {
                                    review = value;
                                  },
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintStyle: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Write a review"),
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 26,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            context
                                .bloc<MyOrdersCubit>()
                                .updateReview(orderModel, index, review)
                                .then((value) {
                              Fluttertoast.showToast(
                                msg: "Thank You for your review !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }).catchError((err) {
                              print(err);
                              Fluttertoast.showToast(
                                msg: "Some Error Occured",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }).whenComplete(
                                    () => myRouter.Router.navigator.pop());
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    "Rate Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
