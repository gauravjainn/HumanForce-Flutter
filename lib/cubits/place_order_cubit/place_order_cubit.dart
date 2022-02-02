import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/models/user_model.dart';
import 'package:human_forces/repositories/order_repository.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  final OrderRepository orderRepository;
  PlaceOrderCubit({this.orderRepository}) : super(PlaceOrderInitial());

  placeOrder(List<ProductModel> productList, UserModel userModel,
      String transaction_id, String total_amount) {
    orderRepository
        .placeOrder(productList, userModel, transaction_id, total_amount)
        .then((value) {
      print("tras successs");
      emit(PlaceOrderSuccess());
    }).catchError(
            (err) => emit(PlaceOrderError("Your order has not been placed !")));
  }

  emitProcessing() {
    emit(PlaceOrderProcessing());
  }

  showError(String message) {
    emit(PlaceOrderProcessing());
    emit(PlaceOrderError(message));
  }
}
