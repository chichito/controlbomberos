import 'dart:async';

import 'package:controlbomberos/domain/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateLoading()) {
    on<CheckUserEvent>(_onCheckUserEvent);
  }

  FutureOr<void> _onCheckUserEvent(
    CheckUserEvent event,
    Emitter<AuthState> emit,
  ) {
    final user = event.user;
    if (user == null) {
      emit(AuthStateLoggedOut());
    } else {
      emit(AuthStateLoggedIn(user: user));
    }
  }
}
