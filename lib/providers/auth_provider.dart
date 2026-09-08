import 'package:chatypy/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/token_model.dart';
import '../models/user_models.dart';

final apiServiceProvider = Provider<ApiService>((ref){
  return ApiService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref){
  return AuthNotifier(
    ref.read(apiServiceProvider),
  );
});

class AuthState{
  final bool isLoading;
  final String? token;
  final UserModel? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.token,
    this.user,
    this.error,
});
}

class AuthNotifier extends  StateNotifier<AuthState>{
  final ApiService apiService;
  AuthNotifier(this.apiService) : super(AuthState());

  Future<void> login(
      String email,
      String password,
      ) async {
    state = AuthState(
      isLoading: true,
    );

    try {
      final TokenModel tokenModel =
      await apiService.login(
        email,
        password,
      );

      final UserModel user =
      await apiService.getCurrentUser(
        tokenModel.accessToken,
      );

      state = AuthState(
        isLoading: false,
        token: tokenModel.accessToken,
        user: user,
      );
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}