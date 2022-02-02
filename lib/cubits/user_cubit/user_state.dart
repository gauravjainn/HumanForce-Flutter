part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserNotLoggedIn extends UserState {
  final UserModel userModel;
  const UserNotLoggedIn(this.userModel);
}

class UserLoggedIn extends UserState {
  final UserModel userModel;
  const UserLoggedIn(this.userModel);
}
