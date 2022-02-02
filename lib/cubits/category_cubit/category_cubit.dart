import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_list_model.dart';
import 'package:human_forces/repositories/category_repository.dart';
import 'package:human_forces/repositories/product_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends HydratedCubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  CategoryCubit(this._categoryRepository, this._productRepository)
      : super(CategoryLoading());

  getCategoryData(String category) {
    emit(const CategoryLoading());
    _categoryRepository.getTypesList(category).then((value) {
      List<String> typesList =
          value.documents.map((e) => e.documentID).toList();
      emit(CategoryLoaded(typesList));
    }).catchError((err) {
      print(err);
      emit(const CategoryError("Unable to fetch Categories"));
    });
  }

  getProductListData(String category, String type) {
    emit(const CategoryProductLoading());
    _productRepository
        .getProductListData(category, type)
        .then(
            (productListModel) => emit(CategoryProductLoaded(productListModel)))
        .catchError((err) {
      emit(const CategoryProductError("Couldn't Load this Category"));
      print(err);
    });
  }

  @override
  CategoryState fromJson(Map<String, dynamic> json) {
    return CategoryLoading();
  }

  @override
  Map<String, dynamic> toJson(CategoryState state) {
    return null;
  }
}
