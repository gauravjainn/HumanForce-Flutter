import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/repositories/login_repository.dart';
import 'package:human_forces/utils/strings.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;
  UserCubit userCubit;

  LoginCubit(this._loginRepository, this.userCubit) : super(LoginInitial());

  Future<void> loginUser(String sellerId, String password) async {
    emit(const LoginProcessing());

    String email = "$sellerId$human_forces_email";
    if (sellerId != null &&
        password != null &&
        sellerId.isNotEmpty &&
        password.isNotEmpty) {
      _loginRepository
          .signInWithCredentials(email, password)
          .then((authResult) {
        Firestore firestore = Firestore.instance;

        firestore.collection("Users").document(sellerId).get().then((value) {
          emit(const LoginCompleted());
          userCubit.emitUserLoggedIn(sellerId, value.data);
        }).catchError((err) =>
            emit(const LoginError("No Seller available with this Seller ID")));
      }).catchError((err) {
        print(err);
        emit(const LoginError("Invalid Credential Please try again"));
      });
    } else {
      if (sellerId == null || sellerId.isEmpty) {
        emit(const LoginError("Seller Id cannot be empty"));
      } else {
        emit(const LoginError("Password cannot be empty"));
      }
    }
  }

  emitLoginInitial() {
    emit(const LoginInitial());
  }

  emitForgotPassword() {
    emit(const LoginForgotPassword());
  }

  Future<void> forgotPassword(String sellerId) async {
    emit(const LoginForgotPasswordProcessing());
    String email = "$sellerId$human_forces_email";
    if (sellerId != null && sellerId.isNotEmpty) {
      _loginRepository
          .forgotPassword(email)
          .then((value) => emit(LoginForgotPasswordEmailSent()))
          .catchError((err) {
        emit(const LoginForgotPasswordError(
            "Cannot sent reset email some error occured"));
      });
    } else {
      emit(const LoginForgotPasswordError("Seller Id cannot be empty"));
    }
  }

  Future<void> signOut() async {
    emit(const LoginSignProcessing());
    await _loginRepository.signOut();

    emit(const LoginSignOut());
    userCubit.emitUserNotLoggedIn();
  }
}
