import 'package:controlbomberos/data/repositories/user/user_repository_impl.dart';
import 'package:controlbomberos/domain/models/user.dart';
import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthBloc authBloc;

  LoginCubit(this.authBloc) : super(LoginState());

  final _userRepository = UserRepositoryImpl();
  void onEmailChanged(String? email) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChanged(String? password) {
    emit(state.copyWith(password: password));
  }

  Future<void> onLogin() async {
    if (state.email == null || state.password == null) {
      emit(state.copyWith(error: 'Email and password cannot be empty'));
      return;
    }
    try {
      final user = await _userRepository.getUserByValidate(
        state.email!,
        state.password!,
      );
      if (user == null) {
        emit(
          state.copyWith(
            status: Status.invalid,
            error: 'Invalid email or password',
          ),
        );
        return;
      }
      authBloc.add(CheckUserEvent(user: user));
      emit(state.copyWith(status: Status.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, error: e.toString()));
    }
  }
}
