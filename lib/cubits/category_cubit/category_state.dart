part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryProductLoading extends CategoryState {
  const CategoryProductLoading();
}

class CategoryProductLoaded extends CategoryState {
  final ProductListModel productListModel;
  const CategoryProductLoaded(this.productListModel);
}

class CategoryProductError extends CategoryState {
  final String message;
  const CategoryProductError(this.message);
}

class CategoryLoaded extends CategoryState {
  final List<dynamic> categoryList;

  const CategoryLoaded(this.categoryList);
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
}
