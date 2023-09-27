part of 'auth_bloc.dart';

abstract class AuthEvent {}

class OnEmailChange extends AuthEvent {
  final String email;
  OnEmailChange(this.email);
}

class OnPasswordChange extends AuthEvent {
  final String password;
  OnPasswordChange(this.password);
}

class OnConfirmPasswordChange extends AuthEvent {
  final String confirmPassword;
  OnConfirmPasswordChange(this.confirmPassword);
}

class OnLoginRequestWithEmail extends AuthEvent {}

class OnSignInRequestWithEmail extends AuthEvent {}

class OnLoginSuccess extends AuthEvent {}
// class OnLoginRequest extends AuthEvent {}
