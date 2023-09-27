import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_t/src/models/user_model.dart';
import 'package:flutter_t/src/services/firebase/firebase_auth.dart';

import '../navigation/navigation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t/src/helpers/helpers.dart';
import 'auth_functions.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NavigationBloc _navigationBloc;
  final firebaseServicesAuth = FirebaseServicesAuth();

  final preferences = Preferences();

  AuthBloc(this._navigationBloc) : super(const AuthState()) {
    on<OnEmailChange>(_mapOnEmailChange);
    on<OnPasswordChange>(_mapOnPasswordChange);
    on<OnConfirmPasswordChange>(_mapOnConfirmPasswordChange);
    on<OnLoginRequestWithEmail>(_mapOnLoginRequestWithEmail);
    on<OnSignInRequestWithEmail>(_mapOnSignInRequestWithEmail);
  }
  void _mapOnEmailChange(event, Emitter emit) async {
    final emailState = validarCorreo(event.email, state.passwordState);
    emit(state.copyWith(
        email: event.email,
        emailState: emailState[0],
        loginButtonState: emailState[1]));
  }

  void _mapOnPasswordChange(event, Emitter emit) async {
    final passwordState = passwordValidator(event.password, state.emailState);
    bool confirmPasswordState = true;
    if (state.confirmPassword.isNotEmpty) {
      confirmPasswordState =
          confirmPasswordValidator(event.password, state.confirmPassword);
    }
    emit(state.copyWith(
      password: event.password,
      passwordState: passwordState[0],
      loginButtonState: passwordState[1],
      confirmPasswordState: confirmPasswordState,
    ));
  }

  void _mapOnConfirmPasswordChange(event, Emitter emit) async {
    final confirmPasswordState =
        confirmPasswordValidator(state.password, event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      confirmPasswordState: confirmPasswordState,
    ));
  }

  void _mapOnLoginRequestWithEmail(event, Emitter emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final credential = await firebaseServicesAuth.signInWithEmail(
          state.email, state.password);
      if (credential == null) return null;
      print(credential);
      User? userFirebase = credential.user;
      if (userFirebase != null) {
        final newUser = UserModel().init();
        newUser.uid = userFirebase.uid;
        newUser.email = userFirebase.email!;
        newUser.name = userFirebase.displayName ?? '';
        newUser.phone = userFirebase.phoneNumber ?? '';
        preferences.user = newUser.toEncodeJson();
        _navigationBloc.add(NavigateToPage("/home", "pushNamed"));
      }
      emit(state.copyWith(
        isLoading: false,
      ));
    } on FirebaseAuthException catch (e) {
      _navigationBloc.add(ShowSnackBar(e.code, "error"));
      emit(state.copyWith(isLoading: false, error: e.code));
    } on Exception catch (e) {
      _navigationBloc.add(ShowSnackBar(e.toString(), "error"));
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _mapOnSignInRequestWithEmail(event, Emitter emit) async {
    try {
      await firebaseServicesAuth
          .createAccount(state.email, state.password)
          .then((User? userFirebase) async {
        if (userFirebase != null) {
          final newUser = UserModel().init();
          newUser.uid = userFirebase.uid;
          newUser.email = userFirebase.email!;
          newUser.name = userFirebase.displayName ?? '';
          newUser.phone = userFirebase.phoneNumber ?? '';

          preferences.user = newUser.toEncodeJson();
          _navigationBloc.add(NavigateToPage("/home", "pushNamed"));
        }
      });
    } on FirebaseAuthException catch (e) {
      _navigationBloc.add(ShowSnackBar(e.message.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    } on Exception catch (e) {
      _navigationBloc.add(ShowSnackBar(e.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    }
  }
}
