import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/pages/payment_screen.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/common_widget.dart';
import 'package:human_forces/widgets/secondary_app_bar.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;

class CheckOutScreen extends StatefulWidget {
  final List<ProductModel> productsList;
  CheckOutScreen({@required this.productsList});
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var total = 0;
  bool showFab = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: showFab
              ? FloatingActionButton.extended(
                  heroTag: "CHECKOUT_EXTENDED",
                  backgroundColor: my_black,
                  onPressed: () {
                    if (state is UserLoggedIn) {
                      showPaymentBottomSheet(context, state);
                    }
                  },
                  label: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Place Order → ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : null,
          // resizeToAvoidBottomPadding: false,
          appBar: SecondaryAppBar(title: "Checkout", height: 56),
          backgroundColor: Colors.black,
          body: BlocListener<PlaceOrderCubit, PlaceOrderState>(
            listener: (context, state) {
              if (state is PlaceOrderProcessing) {
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
                    ),
                  ),
                );
              }
              if (state is PlaceOrderSuccess) {
                myRouter.Router.navigator.pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child: AlertDialog(
                      title: Text("Success"),
                      content: Text("Your order has been placed Successfully"),
                      actions: [
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            context.bloc<CartCubit>().clearCart();
                            context.bloc<NavigatorCubit>().changeRoute("Home");
                            myRouter.Router.navigator.pushNamedAndRemoveUntil(
                                myRouter.Router.humanForces, (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is PlaceOrderError) {
                myRouter.Router.navigator.pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Failed"),
                    content: Text("${state.message}"),
                    actions: [
                      FlatButton(
                        child: Text("Retry"),
                        onPressed: () {
                          myRouter.Router.navigator.pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin:
                      EdgeInsets.only(top: 16, bottom: 0, left: 8, right: 8),
                  padding: EdgeInsets.all(16),
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
                      Text("Delivery Address",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      if (state is UserLoggedIn) ...{
                        selectedAddressSection(state),
                      },
                      Text("Order Summary",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      checkoutItem(),
                      priceSection(),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showPaymentBottomSheet(BuildContext context, UserLoggedIn state) {
    setState(() {
      showFab = false;
    });
    return _scaffoldKey.currentState
        .showBottomSheet((context) {
          return PaymentScreen(
            amount: total,
            productList: widget.productsList,
            userModel: state.userModel,
          );
        },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            backgroundColor: Colors.white,
            elevation: 2)
        .closed
        .then((value) {
          setState(() {
            showFab = true;
          });
        });
  }

  selectedAddressSection(UserLoggedIn state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            getCircleAvatar(50, 50, state.userModel.name ?? "", 12),
            SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${state.userModel.name}",
                  style: CustomTextStyle.textFormFieldSemiBold
                      .copyWith(fontSize: 14, color: Colors.grey),
                ),
                createAddressText("${state.userModel.address}", 6),
                createAddressText("${state.userModel.pincode}", 6),
                SizedBox(
                  height: 6,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Mobile : ",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(fontSize: 13, color: Colors.grey)),
                    TextSpan(
                        text: "${state.userModel.mobile_number}",
                        style: CustomTextStyle.textFormFieldBold
                            .copyWith(color: Colors.grey, fontSize: 13)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Standard Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Get it by 3 - 4 Working Days ",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  checkoutItem() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(widget.productsList[index]);
      },
      itemCount: widget.productsList.length,
      shrinkWrap: true,
      primary: false,
      scrollDirection: Axis.vertical,
    );
  }

  _buildListItem(ProductModel product) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 5,
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: product.image[0],
                fit: BoxFit.fill,
                placeholder: (context, url) => LinearProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8),
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
                              ? "Quantity : ${product.quantity_batches}"
                              : "Quantity : ${product.quantity_size}",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                          child: Text(
                              product.orderType == OrderType.batches
                                  ? "Price : ₹ ${product.price_batches} X ${product.quantity_batches} = ₹ ${int.parse(product.price_batches) * product.quantity_batches}"
                                  : "Price : ₹ ${product.price_size} X ${product.quantity_size} = ₹ ${int.parse(product.price_size) * product.quantity_size}",
                              style: TextStyle(color: Colors.blue)))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  priceSection() {
    total = 0;
    widget.productsList.forEach((e) => total += (int.parse(
            e.orderType == OrderType.batches ? e.price_batches : e.price_size) *
        (e.orderType == OrderType.batches
            ? e.quantity_batches
            : e.quantity_size)));
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300)),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(
        top: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Text(
            "PRICE DETAILS",
            style: CustomTextStyle.textFormFieldMedium.copyWith(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey.shade400,
          ),
          SizedBox(
            height: 8,
          ),
          createPriceItem("Order Total", "₹ $total.00", Colors.grey.shade700),
          createPriceItem("Delievery Charges", "FREE", Colors.teal.shade300),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey.shade400,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Total",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(color: Colors.black, fontSize: 13),
              ),
              Text(
                "₹ $total.00",
                style: CustomTextStyle.textFormFieldMedium
                    .copyWith(color: Colors.black, fontSize: 13),
              )
            ],
          )
        ],
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 13),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 13),
          )
        ],
      ),
    );
  }
}

class CustomTextStyle {
  static var textFormFieldRegular =
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);

  static var textFormFieldLight =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

  static var textFormFieldSemiBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);
}
