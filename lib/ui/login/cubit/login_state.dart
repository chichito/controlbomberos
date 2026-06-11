part of 'login_cubit.dart';

enum Status { initial, loading, success, invalid, failure }

class LoginState {
  final Status? status;
  final String? email;
  final String? password;
  final String? error;
  final User? user;

  LoginState({this.status, this.email, this.password, this.error, this.user});

  LoginState copyWith({
    String? email,
    String? password,
    Status? status,
    String? error,
    User? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
