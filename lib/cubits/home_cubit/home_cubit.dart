import 'package:equatable/equatable.dart';
import 'package:human_forces/models/home_model.dart';
import 'package:human_forces/repositories/home_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_state.dart';

class HomeCubit extends HydratedCubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeLoading());

  getHomeScreenData() {
    emit(const HomeLoading());
    _homeRepository.getHomeScreenData().then((value) {
      HomeModel homeModel = HomeModel.fromJson(value);
      emit(HomeLoaded(homeModel));
    }).catchError((err) {
      print(err);
      emit(const HomeError("Unable to fetch Data"));
    });
  }

  @override
  HomeState fromJson(Map<String, dynamic> json) {
    return HomeLoading();
  }

  @override
  Map<String, dynamic> toJson(HomeState state) {
    return null;
  }
}
