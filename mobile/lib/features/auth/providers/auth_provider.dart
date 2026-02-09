import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exceptions.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

/// Convenience provider: true when user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is Authenticated;
});

/// Convenience provider: current user or null.
final currentUserProvider = Provider<UserModel?>((ref) {
  final state = ref.watch(authProvider);
  if (state is Authenticated) return state.user;
  return null;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  /// Check if user has a valid session on app startup.
  Future<void> checkSession() async {
    state = const AuthLoading();
    try {
      final hasSession = await _repository.hasSession();
      if (!hasSession) {
        state = const Unauthenticated();
        return;
      }
      final user = await _repository.getProfile();
      state = Authenticated(user);
    } on UnauthorizedException {
      state = const Unauthenticated();
    } catch (e) {
      state = const Unauthenticated();
    }
  }

  /// Login with phone and password.
  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      state = Authenticated(user);
    } on ValidationException catch (e) {
      state = AuthError(e.message, fieldErrors: e.fieldErrors);
    } on ApiException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Register a new user.
  Future<void> register({
    required String phoneNumber,
    required String password,
    required String passwordConfirm,
    required String firstName,
    String? lastName,
    String? email,
    String role = 'tenant',
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.register(
        phoneNumber: phoneNumber,
        password: password,
        passwordConfirm: passwordConfirm,
        firstName: firstName,
        lastName: lastName ?? '',
        email: email,
        role: role,
      );
      state = Authenticated(user);
    } on ValidationException catch (e) {
      state = AuthError(e.message, fieldErrors: e.fieldErrors);
    } on ApiException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Logout current user.
  Future<void> logout() async {
    await _repository.logout();
    state = const Unauthenticated();
  }

  /// Update user in state (e.g. after profile edit).
  void updateUser(UserModel user) {
    state = Authenticated(user);
  }
}
