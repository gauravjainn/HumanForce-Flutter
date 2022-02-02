part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeModel homeModel;
  const HomeLoaded(this.homeModel);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
