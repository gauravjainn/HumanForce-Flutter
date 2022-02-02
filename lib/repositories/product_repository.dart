import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:human_forces/models/cloth_type_detail_model.dart';
import 'package:human_forces/models/product_list_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';

class ProductRepository {
  final Firestore _firestore;

  ProductRepository() : _firestore = Firestore.instance;

  Stream<ProductModel> getProductDetailAsStream(
      ProductSelectorModel productSelectorModel) {
    return _firestore
        .collection("Human Force")
        .document('Category')
        .collection(productSelectorModel.catergory)
        .document(productSelectorModel.sub_catergory)
        .collection("Products")
        .document(productSelectorModel.productModel.id)
        .snapshots()
        .map((document) => ProductModel.fromJson(document.data)
            .copyWith(dbPath: document.reference.path));
  }

  Future<List<ProductModel>> getSectionBasedProductList(String section) async {
    List<ProductModel> productList = List();
    Future<QuerySnapshot> productListRef = _firestore
        .collection("Human Force")
        .document(section)
        .collection("Products")
        .getDocuments();
    QuerySnapshot allProducts = await productListRef;

    allProducts.documents.forEach((element) {
      ProductModel p = ProductModel.fromJson(element.data);
      print("Product props" + p.props.toString());
      productList.add(p);
    });
    return productList;
  }

  Future<ProductListModel> getProductListData(
      String category, String type) async {
    final dataList = await Future.wait([
      _getTypeDetails(category, type),
      _getProductList(category, type),
    ]);

    return ProductListModel(
      title: category,
      sub_title: type,
      details: dataList[0],
      all_products: dataList[1],
      products: dataList[1],
      clothTypeFilter: "",
      colorFilter: "",
      subCategoryFilter: "",
      isFilter: false,
    );
  }

  Future<List<ProductModel>> _getProductList(
      String category, String type) async {
    List<ProductModel> productList = List();

    Future<QuerySnapshot> productListRef = _firestore
        .collection("Human Force")
        .document("Category")
        .collection(category)
        .document(type)
        .collection("Products")
        .getDocuments();

    QuerySnapshot allProducts = await productListRef;

    allProducts.documents.forEach((element) {
      try {
        ProductModel p = ProductModel.fromJson(element.data);
        print("Product" + p.toJson().toString());
        productList.add(p);
      } catch (e) {
        print(e);
      }
    });

    return productList;
  }

  Future<ClothTypeDetailModel> _getTypeDetails(
      String category, String type) async {
    Future<DocumentSnapshot> _clothTypeDetailsRef = _firestore
        .collection("Human Force")
        .document("Category")
        .collection(category)
        .document(type)
        .get();

    DocumentSnapshot _clothTypeDetailSnapshot = await _clothTypeDetailsRef;
    ClothTypeDetailModel clothTypeDetail;
    try {
      clothTypeDetail =
          ClothTypeDetailModel.fromJson(_clothTypeDetailSnapshot.data);
    } catch (e) {
      print(e);
    }
    return clothTypeDetail;
  }
}
