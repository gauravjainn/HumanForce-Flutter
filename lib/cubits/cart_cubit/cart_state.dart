part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartItemAdding extends CartState {
  const CartItemAdding();
}

class CartItemRemoving extends CartState {
  const CartItemRemoving();
}

class CartItemLoaded extends CartState {
  final List<ProductModel> productsList;
  CartItemLoaded(this.productsList);
}

class CartItemError extends CartState {
  final String message;
  CartItemError(this.message);
}

class CartItemLoading extends CartState {
  CartItemLoading();
}
