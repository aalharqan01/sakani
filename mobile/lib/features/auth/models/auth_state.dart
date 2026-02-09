import 'user_model.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? message;
  const Unauthenticated({this.message});
}

class AuthError extends AuthState {
  final String message;
  final Map<String, List<String>>? fieldErrors;
  const AuthError(this.message, {this.fieldErrors});
}
