import 'package:finager/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authDataNotifier = AuthStateNotifier(ref);
  // Fetch Data on initialization
  return authDataNotifier;
});

class AuthState {
  final bool isLoading;
  final String displayName;
  final String username;
  final String accessToken;
  final bool hasSession;
  final int userId;
  final String? profileImageUrl;

  AuthState({
    required this.isLoading,
    required this.username,
    required this.accessToken,
    required this.displayName,
    required this.hasSession,
    required this.userId,
    this.profileImageUrl,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? hasSession,
    String? username,
    String? accessToken,
    String? displayName,
    int? userId,
    String? profileImageUrl,
  }) {
    return AuthState(
      hasSession: hasSession ?? this.hasSession,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

// AuthStateNotifier handles the logic for fetching and updating the state
class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthStateNotifier(this.ref)
    : super(
        AuthState(
          hasSession: false,
          isLoading: false,
          username: 'Unknown',
          userId: 0,
          accessToken: '',
          displayName: '',
          profileImageUrl: null,
        ),
      ) {
    // load settings when intialized;
  }

  Future<bool> login(Map<String, dynamic> loginData, error) async {
    state = state.copyWith(isLoading: true);
    try {
      final authService = AuthService();
      final data = await authService.loginService(loginData);
      if (data['success'] == true) {
        state = state.copyWith(
          hasSession: true,
          username: data['username'],
          accessToken: data['accessToken'],
          displayName: data['displayName'],
          userId: data['userId'],
          profileImageUrl: data['profileImageUrl'],
        );
        debugPrint("Login successful: ${data['accessToken']}");
        return true;
      } else {
        debugPrint("Login failed: ${data['success']}");
        error = "Password or Username Incorrect";
        return false;
      }
    } catch (e) {
      error = "Password or Username Incorrect: ERROR!";
      debugPrint("Error: $e");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final authService = AuthService();
    await authService.logout();
    state = state.copyWith(hasSession: false);
    state = state.copyWith(isLoading: false);
  }
}
