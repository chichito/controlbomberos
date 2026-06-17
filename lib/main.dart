import 'package:controlbomberos/db/bloc/db_bloc.dart';
import 'package:controlbomberos/error/error_db.dart';
import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/auth/view/auth_handler.dart';
import 'package:controlbomberos/ui/core/navigation/app_navigator.dart';
import 'package:controlbomberos/ui/core/themes/theme.dart';
import 'package:controlbomberos/ui/emergencia/bloc/emergencia_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/retroalimentacion_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/tiempos_bloc.dart';
import 'package:controlbomberos/ui/emergencia/view/emergencia_page.dart';
import 'package:controlbomberos/ui/fotosvideos/bloc/fotosvideos_bloc.dart';
import 'package:controlbomberos/ui/gps/bloc/gps_bloc.dart';
import 'package:controlbomberos/ui/gps/view/gps_page.dart';
import 'package:controlbomberos/ui/home/view/home_page.dart';
import 'package:controlbomberos/ui/inicio/view/inicio_page.dart';
import 'package:controlbomberos/ui/login/cubit/login_cubit.dart';
import 'package:controlbomberos/ui/login/view/login_page.dart';
import 'package:controlbomberos/ui/root/view/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* bine
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: AppTheme.light,
      home: InicioPage(),
    );
*/

    return MultiBlocProvider(
      providers: [
        BlocProvider<GpsBloc>(
          create: (context) => GpsBloc()
            ..add(GpsInitialStatusEvent())
            ..add(ChangeGpsStatusEvent()),
        ),
        BlocProvider<DbBloc>(
          lazy: false,
          create: (context) => DbBloc()..add(DBInitialStatusEvent()),
        ),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(context.read<AuthBloc>()),
        ),
      ],
      child: AuthHandler(
        navigatorKey: navigatorKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: AppTheme.light,
          routes: {
            AppNavigator.main: (_) => RootPage(),
            AppNavigator.inicio: (_) => InicioPage(),
            AppNavigator.login: (_) => LoginPage(),
            AppNavigator.home: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => EmergenciaBloc()..add(GetEmergenciaAllEvent()),
                ),
                BlocProvider(
                  create: (context) =>
                      TiemposBloc(context.read<EmergenciaBloc>()),
                ),
              ],
              child: HomePage(),
            ),
            AppNavigator.emergencia: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => EmergenciaBloc()),
                BlocProvider(create: (_) => RetroalimentacionBloc()),
                BlocProvider(create: (_) => FotosVideosBloc()),
                BlocProvider(
                  create: (context) =>
                      TiemposBloc(context.read<EmergenciaBloc>()),
                ),
              ],
              child: EmergenciaPage(),
            ),
            AppNavigator.gps: (_) => GpsPage(),
            AppNavigator.errordb: (_) => ErrorDbPage(),
          },
        ),
      ),
    );
  }
}
