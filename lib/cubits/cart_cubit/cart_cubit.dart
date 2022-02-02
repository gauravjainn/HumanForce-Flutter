import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'cart_state.dart';

class CartCubit extends HydratedCubit<CartState> {
  final List<ProductModel> _productList;
  CartCubit(this._productList) : super(CartItemLoaded(List()));
  clearCart() {
    emit(CartItemRemoving());
    _productList.clear();
    emit(CartItemLoaded(this._productList));
  }

  addItem(ProductModel product, int quantity_batches, int quantity_size,
      dynamic selectedColor, String selectedSize, OrderType orderType,
      {int index}) {
    emit(CartItemAdding());

    product = product.copyWith(
        quantity_size: quantity_size,
        quantity_batches: quantity_batches,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
        orderType: orderType);

    if (_productList.contains(product)) {
      print("same product");
      ProductModel pTemp;
      pTemp = _productList.firstWhere((element) => product == element);
      orderType == OrderType.batches
          ? product = pTemp.copyWith(
              quantity_batches:
                  (pTemp?.quantity_batches ?? 0) + quantity_batches,
            )
          : product = pTemp.copyWith(
              quantity_size: (pTemp?.quantity_size ?? 0) + quantity_size,
            );
      index != null ? _productList.removeAt(index) : _productList.remove(pTemp);
      pTemp = null;
    }
    index != null
        ? _productList.insert(index, product)
        : _productList.add(product);
    product = null;
    emit(CartItemLoaded(this._productList));
  }

  removeAllItemQuantity(ProductModel product) {
    emit(CartItemRemoving());
    _productList.remove(product);
    emit(CartItemLoaded(this._productList));
  }

  removeItem(ProductModel product, int index) {
    emit(CartItemRemoving());

    if (product.orderType == OrderType.batches) {
      if (product.quantity_batches > product.min_quantity) {
        ProductModel pTemp;
        pTemp = product.copyWith(
          quantity_batches: (product.quantity_batches ?? 0) - 1,
        );

        _productList.removeAt(index);

        _productList.insert(index, pTemp);
        pTemp = null;
      } else {
        _productList.remove(product);
      }
    } else {
      if (product.quantity_size > 1) {
        ProductModel pTemp;
        pTemp = product.copyWith(
          quantity_size: (product.quantity_size ?? 0) - 1,
        );
        _productList.removeAt(index);

        _productList.insert(index, pTemp);
        pTemp = null;
      } else {
        _productList.remove(product);
      }
    }
    product = null;
    emit(CartItemLoaded(this._productList));
  }

  @override
  CartState fromJson(Map<String, dynamic> json) {
    return CartItemLoading();
  }

  @override
  Map<String, dynamic> toJson(CartState state) {
    return null;
  }
}
