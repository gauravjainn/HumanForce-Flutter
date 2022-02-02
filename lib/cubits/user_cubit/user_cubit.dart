import 'package:equatable/equatable.dart';
import 'package:human_forces/models/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_state.dart';

class UserCubit extends HydratedCubit<UserState> {
  UserCubit()
      : super(UserNotLoggedIn(const UserModel(
            isUserLoggedIn: false,
            name: "",
            id: "",
            bond: "",
            customer_id: "",
            joined_from: "",
            retailer_id: "",
            shop_name: "",
            address: "",
            pincode: "",
            mobile_number: "",
            all_orders: [],
            sellerId: "")));

  emitUserNotLoggedIn() {
    const UserModel user = UserModel(
        isUserLoggedIn: false,
        name: "",
        bond: "",
        id: "",
        customer_id: "",
        joined_from: "",
        retailer_id: "",
        shop_name: "",
        address: "",
        pincode: "",
        mobile_number: "",
        all_orders: [],
        sellerId: "");
    emit(const UserNotLoggedIn(user));
  }

  emitUserLoggedIn(String sellerId, Map<String, dynamic> json) {
    json["isUserLoggedIn"] = true;
    json["sellerId"] = sellerId;
    UserModel user = UserModel.fromJson(json);

    emit(UserLoggedIn(user));
  }

  @override
  UserState fromJson(Map<String, dynamic> json) {
    try {
      final user = UserModel.fromJson(json);
      if (user.isUserLoggedIn) {
        return UserLoggedIn(user);
      }
      return UserNotLoggedIn(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(UserState state) {
    if (state is UserLoggedIn) {
      return state.userModel.toJson();
    }
    return null;
  }
}
