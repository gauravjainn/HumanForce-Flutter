import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/strings.dart';

class CartFabButton extends StatefulWidget {
  final Color fabColor;
  final double fabSize;
  final bool isCountRight;

  const CartFabButton({this.fabColor, this.fabSize, this.isCountRight = false});

  @override
  _CartFabButtonState createState() => _CartFabButtonState();
}

class _CartFabButtonState extends State<CartFabButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      if (state is CartItemLoaded) {
        return Stack(children: [
          FloatingActionButton(
            heroTag: "CART",
            backgroundColor: widget.fabColor ?? my_black,
            child: Icon(
              Icons.shopping_bag_rounded,
              size: widget.fabSize,
            ),
            onPressed: () {
              myRouter.Router.navigator.pushNamed(myRouter.Router.cartScreen);
            },
          ),
          state.productsList.length > 0
              ? (widget.isCountRight
                  ? Positioned(
                      right: 6,
                      top: 6,
                      child: _buildUi(state),
                    )
                  : _buildUi(state))
              : SizedBox(),
        ]);
      }
      return Container();
    });
  }

  _buildUi(CartState state) {
    if (state is CartItemLoaded) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            "${state.productsList.length}",
          ),
        ),
      );
    }
  }
}
