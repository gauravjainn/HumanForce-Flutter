part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  final ProductSelectorModel productSelectorModel;
  const ProductState(this.productSelectorModel);

  @override
  List<Object> get props => [];
}

class AddToCartInitial extends ProductState {
  AddToCartInitial(ProductSelectorModel productSelectorModel)
      : super(productSelectorModel);
}

class AddToCartProcessing extends ProductState {
  AddToCartProcessing(ProductSelectorModel productSelectorModel)
      : super(productSelectorModel);
}

class AddToCartAdded extends ProductState {
  AddToCartAdded(ProductSelectorModel productSelectorModel)
      : super(productSelectorModel);
}
