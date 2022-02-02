import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/repositories/product_repository.dart';

part 'product_list_without_filter_state.dart';

class ProductListWithoutFilterCubit extends Cubit<List<ProductModel>> {
  final ProductRepository productRepository;

  ProductListWithoutFilterCubit({
    this.productRepository,
  }) : super(List());

  getProductListForSection(String section) {
    productRepository
        .getSectionBasedProductList(section)
        .then((productList) => emit(productList))
        .catchError((err) {
      emit(List());
    });
  }
}
