part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginProcessing extends LoginState {
  const LoginProcessing();
}

class LoginCompleted extends LoginState {
  const LoginCompleted();
}

class LoginForgotPassword extends LoginState {
  const LoginForgotPassword();
}

class LoginForgotPasswordProcessing extends LoginState {
  const LoginForgotPasswordProcessing();
}

class LoginForgotPasswordError extends LoginState {
  final String message;
  const LoginForgotPasswordError(this.message);
}

class LoginForgotPasswordEmailSent extends LoginState {
  const LoginForgotPasswordEmailSent();
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}

class LoginSignOut extends LoginState {
  const LoginSignOut();
}

class LoginSignProcessing extends LoginState {
  const LoginSignProcessing();
}
