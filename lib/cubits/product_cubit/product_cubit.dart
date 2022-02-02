import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductSelectorModel productSelectorModel;
  final ProductRepository productRepository;

  ProductCubit(this.productRepository, {this.productSelectorModel})
      : super(AddToCartInitial(productSelectorModel));

  getProductDetailsAsStream() {
    return productRepository.getProductDetailAsStream(productSelectorModel);
  }

  changeSelectedColor(ProductState state,
      ProductSelectorModel productSelectorModel, dynamic selectedColor) {
    emit(AddToCartProcessing(productSelectorModel));
    if (state is AddToCartAdded) {
      emit(AddToCartAdded(
          productSelectorModel.copyWith(selectedColor: selectedColor)));
    } else {
      emit(AddToCartInitial(
          productSelectorModel.copyWith(selectedColor: selectedColor)));
    }
  }

  changeOrderType(ProductState state, ProductSelectorModel productSelectorModel,
      int index) {
    emit(AddToCartProcessing(productSelectorModel));
    if (state is AddToCartAdded) {
      emit(AddToCartAdded(productSelectorModel.copyWith(
          orderType: OrderType.values[index],
          selectedSizes: OrderType.values[index] == OrderType.batches
              ? productSelectorModel.productModel.batches[0]['name']
              : productSelectorModel.productModel.size[0]['name'])));
    } else {
      emit(AddToCartInitial(productSelectorModel.copyWith(
          orderType: OrderType.values[index],
          selectedSizes: OrderType.values[index] == OrderType.batches
              ? productSelectorModel.productModel.batches[0]['name']
              : productSelectorModel.productModel.size[0]['name'])));
    }
  }

  changeQuantity(ProductState state, ProductSelectorModel productSelectorModel,
      {int quantity_batches, int quantity_size}) {
    if (productSelectorModel.orderType == OrderType.batches) {
      if (quantity_batches >= 0) {
        emit(AddToCartProcessing(productSelectorModel));
        if (state is AddToCartAdded) {
          emit(AddToCartAdded(productSelectorModel.copyWith(
              quantity_batches: quantity_batches)));
        } else {
          emit(AddToCartInitial(productSelectorModel.copyWith(
              quantity_batches: quantity_batches)));
        }
      }
    } else {
      if (quantity_size >= 0) {
        emit(AddToCartProcessing(productSelectorModel));
        if (state is AddToCartAdded) {
          emit(AddToCartAdded(
              productSelectorModel.copyWith(quantity_size: quantity_size)));
        } else {
          emit(AddToCartInitial(
              productSelectorModel.copyWith(quantity_size: quantity_size)));
        }
      }
    }
  }

  changeSelectedSizes(ProductState state,
      ProductSelectorModel productSelectorModel, String selectedSizes) {
    emit(AddToCartProcessing(productSelectorModel));
    if (state is AddToCartAdded) {
      emit(AddToCartAdded(
          productSelectorModel.copyWith(selectedSizes: selectedSizes)));
    } else {
      emit(AddToCartInitial(
          productSelectorModel.copyWith(selectedSizes: selectedSizes)));
    }
  }

  emitItemAdded() {
    emit(AddToCartAdded(productSelectorModel));
  }

  emitAddMoreItem() {
    emit(AddToCartInitial(productSelectorModel));
  }
}
