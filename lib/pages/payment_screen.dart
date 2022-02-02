import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/user_model.dart';
import 'package:upi_india/upi_india.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;

class PaymentScreen extends StatefulWidget {
  final int amount;

  final UserModel userModel;
  final List<ProductModel> productList;

  const PaymentScreen(
      {@required this.amount,
      @required this.userModel,
      @required this.productList})
      : super();
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;

  @override
  void initState() {
    print(widget.amount);
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(String app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: '9680346841@paytm',
      receiverName: 'TUSHAR ANCHLIYA JAIN',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app.app);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        ListTile(
            leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            myRouter.Router.navigator.pop();
          },
        )),
        Center(child: Text("Total Amount : ${widget.amount}")),
        displayUpiApps(),
        FutureBuilder(
          future: _transaction,
          builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Text(" ");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('An Unknown error has occured'));
              }
              UpiResponse _upiResponse;
              _upiResponse = snapshot.data;
              String text = 'Transaction failed try again';
              if (_upiResponse.error != null) {
                switch (snapshot.data.error) {
                  case UpiError.APP_NOT_INSTALLED:
                    text = "Requested app not installed on device";

                    break;
                  case UpiError.INVALID_PARAMETERS:
                    text = "Requested app cannot handle the transaction";
                    break;
                  case UpiError.NULL_RESPONSE:
                    text = "Requested app didn't returned any response";
                    break;
                  case UpiError.USER_CANCELLED:
                    text = "You cancelled the transaction";
                    break;
                }
                BlocProvider.of<PlaceOrderCubit>(context).showError(text);
              }
              String txnId = _upiResponse.transactionId;
              String status = _upiResponse.status;
              switch (status) {
                case UpiPaymentStatus.SUCCESS:
                  print('Transaction Successful');
                  BlocProvider.of<PlaceOrderCubit>(context).placeOrder(
                      widget.productList,
                      widget.userModel,
                      txnId,
                      "${widget.amount}");
                  break;
                case UpiPaymentStatus.SUBMITTED:
                  BlocProvider.of<PlaceOrderCubit>(context).emitProcessing();
                  print('Transaction Submitted');
                  break;
                case UpiPaymentStatus.FAILURE:
                  BlocProvider.of<PlaceOrderCubit>(context).showError(text);
                  print('Transaction Failed');
                  break;
                default:
                  BlocProvider.of<PlaceOrderCubit>(context)
                      .showError("Received an Unknown transaction status");
                  print('Received an Unknown transaction status');
              }
              return Text(" ");
            } else
              return CircularProgressIndicator();
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
