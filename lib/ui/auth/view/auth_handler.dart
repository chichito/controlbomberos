import 'package:controlbomberos/db/bloc/db_bloc.dart';
import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/core/navigation/app_navigator.dart';
import 'package:controlbomberos/ui/gps/bloc/gps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({
    super.key,
    required this.child,
    required this.navigatorKey,
  });
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GpsBloc, GpsState>(
          listener: (BuildContext context, GpsState state) {
            if (!state.isAllEnable) {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.gps,
                (route) => false,
              );
            } else {
              //context.read<DbBloc>().add(DBInitialStatusEvent());
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.inicio,
                (route) => false,
              );
            }
          },
        ),
        BlocListener<DbBloc, DbState>(
          listener: (BuildContext context, DbState state) {
            if (state is DBConnectedState) {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.login,
                (route) => false,
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is AuthStateLoggedIn) {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.home,
                (route) => false,
              );
            }
            if (state is AuthStateLoggedOut) {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.login,
                (route) => false,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
