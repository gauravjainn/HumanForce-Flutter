import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_list_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:meta/meta.dart';
part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListModel> {
  final ProductListModel productListModel;
  ProductListCubit({this.productListModel}) : super(productListModel);

  List<ProductModel> applyColorFilter({
    ProductListModel productListModel,
    String colorFilter,
  }) {
    List<ProductModel> products =
        productListModel.all_products.where((element) {
      return (colorFilter.isNotEmpty
          ? element.color?.firstWhere((color) => color['name'] == colorFilter,
                      orElse: () => false) !=
                  false
              ? true
              : false
          : true);
    }).toList();
    return products;
  }

  List<ProductModel> applySubCategoryFilter(
      {List<ProductModel> productList, String subCategoryFilter = ""}) {
    List<ProductModel> products = productList.where((element) {
      return (subCategoryFilter.isNotEmpty
          ? element.sub_category == subCategoryFilter
          : true);
    }).toList();
    return products;
  }

  List<ProductModel> applyClothFilter(
      {String clothTypeFilter, List<ProductModel> all_products}) {
    List<ProductModel> products;
    if (clothTypeFilter.trim().toUpperCase() == "ALL PRODUCTS") {
      products = all_products;
    } else {
      products = all_products
          .where((element) => clothTypeFilter.isNotEmpty
              ? (element.category ?? "").trim().toUpperCase() ==
                  clothTypeFilter.trim().toUpperCase()
              : true)
          .toList();
    }
    return products;
  }

  List<ProductModel> applyFilters(
      {@required ProductListModel productListModel,
      String clothTypeFilter,
      String colorFilter,
      String subCategoryFilter}) {
    List<ProductModel> products;
    print("subCategoryFilter" + subCategoryFilter.toString());

    List<ProductModel> previousProductFilters = applyColorFilter(
      productListModel: productListModel,
      colorFilter: colorFilter ?? productListModel.colorFilter,
    );
    if (productListModel.details.categories != null) {
      if (productListModel.details.categories[clothTypeFilter] != null) {
        previousProductFilters = applySubCategoryFilter(
            productList: previousProductFilters,
            subCategoryFilter:
                subCategoryFilter ?? productListModel.subCategoryFilter);
      }
    }

    products = applyClothFilter(
        clothTypeFilter: clothTypeFilter ?? productListModel.clothTypeFilter,
        all_products: previousProductFilters);

    products.map((e) => print(e.name));

    return products;
  }

  emitClothTypeFilter(
    ProductListModel productListModel,
    String clothTypeFilter,
  ) {
    List<ProductModel> products = applyFilters(
        productListModel: productListModel, clothTypeFilter: clothTypeFilter);

    emit(productListModel.copyWith(
        products: products, isFilter: true, clothTypeFilter: clothTypeFilter));
  }

  emitColorCategoryFilter(
      {ProductListModel productListModel,
      String colorFilter,
      String subCategoryFilter}) {
    List<ProductModel> products = applyFilters(
      productListModel: productListModel,
      colorFilter: colorFilter,
      subCategoryFilter: subCategoryFilter,
      clothTypeFilter: productListModel.clothTypeFilter,
    );

    emit(productListModel.copyWith(
      products: products,
      isFilter: true,
      colorFilter: colorFilter,
      subCategoryFilter: subCategoryFilter,
    ));
  }
}
