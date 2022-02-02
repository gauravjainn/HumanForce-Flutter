part of 'place_order_cubit.dart';

abstract class PlaceOrderState extends Equatable {
  const PlaceOrderState();

  @override
  List<Object> get props => [];
}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderSuccess extends PlaceOrderState {}

class PlaceOrderError extends PlaceOrderState {
  final String message;
  PlaceOrderError(this.message);
}

class PlaceOrderProcessing extends PlaceOrderState {}
