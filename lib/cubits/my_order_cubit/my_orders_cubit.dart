import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:human_forces/models/order_model.dart';
import 'package:human_forces/repositories/order_repository.dart';
import 'package:intl/intl.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<List<OrderModel>> {
  final OrderRepository orderRepository;
  MyOrdersCubit(this.orderRepository) : super(List());

  getMyOrders(String userId) {
    print("get orders called");
    return orderRepository.getMyOrders(userId).then((value) {
      value.sort((a, b) {
        final d1 = DateFormat.yMd().parse(a.order_date);
        final d2 = DateFormat.yMd().parse(b.order_date);
        return d1.difference(d2).inDays;
      });
      emit(value.reversed.toList());
    }).catchError((err) {
      print("some error in fetching" + err);
      emit(List());
    });
  }

  Future<void> updateReview(OrderModel orderModel, int index, String review) {
    return orderRepository.updateReview(orderModel, index, review);
  }
}
