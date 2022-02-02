import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:human_forces/models/order_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/models/user_model.dart';
import 'package:intl/intl.dart';

class OrderRepository {
  final Firestore _firestore;

  OrderRepository() : _firestore = Firestore.instance;

  Future<List<OrderModel>> getMyOrders(String userId) async {
    List<OrderModel> myOrders = List();

    var userRef = _firestore.collection("Users").document(userId);

    var userData = await userRef.get();

    UserModel user = UserModel.fromJson(userData.data);

    await Future.forEach(user.all_orders ?? [], ((element) async {
      DocumentSnapshot document = await _firestore.document(element).get();

      OrderModel myOrder = OrderModel.fromJson(document.data);
      myOrder = myOrder.copyWith(id: document.documentID);

      myOrders.add(myOrder);
    }));

    return myOrders;
  }

  Future<void> updateReview(OrderModel orderModel, int index, String review) {
    ProductModel productModel =
        orderModel.products[index].copyWith(review: review);

    orderModel.products.removeAt(index);
    orderModel.products.insert(index, productModel);

    print(orderModel.products.length);
    var reviewRef = _firestore.collection("All Orders").document(orderModel.id);

    return reviewRef.updateData(orderModel.toJson());
  }

  Future<void> placeOrder(List<ProductModel> productList, UserModel userModel,
      String transaction_id, String total_amount) async {
    var allOrderRef = _firestore.collection("All Orders");
    var updateRef = await updateOrderQuantiy(productList);
    print(updateRef);

    final now = new DateTime.now();
    String order_date = DateFormat.yMd().format(now);

    OrderModel my_order = OrderModel(
        id: "",
        status: "PENDING",
        delivery_date: "",
        user_id: userModel.sellerId,
        order_date: order_date,
        transaction_id: transaction_id,
        total_amount: total_amount,
        products: productList);

    print(my_order.toJson());
    DocumentReference documentReference =
        await allOrderRef.add(my_order.toJson());

    return addOrderToUserId(documentReference.path, userModel.sellerId);
  }

  Future<dynamic> updateOrderQuantiy(List<ProductModel> products) async {
    return Future.forEach(
        products,
        (ProductModel element) async => {
              if (element.orderType == OrderType.batches)
                {
                  await _firestore.document(element.dbPath).setData(element
                      .copyWith(
                          batches: element.batches
                              .map((e) => e['name'] == element.selectedSize
                                  ? {
                                      'name': element.selectedSize,
                                      'quantity': (int.parse(e['quantity']) -
                                              element.quantity_batches)
                                          .toString()
                                    }
                                  : e)
                              .toList())
                      .toJson())
                }
              else
                {
                  await _firestore.document(element.toString()).setData(element
                      .copyWith(
                          size: element.size
                              .map((e) => e['name'] == element.selectedSize
                                  ? {
                                      'name': element.selectedSize,
                                      'quantity': (int.parse(e['quantity']) -
                                              element.quantity_size)
                                          .toString()
                                    }
                                  : e)
                              .toList())
                      .toJson())
                }
            });
  }

  Future<void> addOrderToUserId(
    String path,
    String userId,
  ) async {
    var userRef = _firestore.collection("Users").document(userId);
    var userData = await userRef.get();
    UserModel user = UserModel.fromJson(userData.data);
    UserModel all_order =
        user.copyWith(all_orders: [...user.all_orders ?? [], path]);
    return userRef.updateData(all_order.toJson());
  }
}
