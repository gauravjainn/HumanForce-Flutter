import 'package:bloc/bloc.dart';

class NavigatorCubit extends Cubit<String> {
  NavigatorCubit() : super("Home");
  changeRoute(String route) => emit(route);
  getCurrentScreen() => state;
}
