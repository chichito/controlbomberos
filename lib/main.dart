import 'package:controlbomberos/data/services/emergencia_servicio.dart';
import 'package:controlbomberos/data/services/injection.dart';
import 'package:controlbomberos/data/services/requestnotificationpermission_service.dart';
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
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Para dar permisos a las notificaciones
  await requestNotificationPermission(null);

  // Encender el monitor de emergencias
  await initializeEmergencyService();
  await initDependencies();
  FlutterBackgroundService().on('nuevaEmergencia').listen((event) {
    print('Nueva emergencia recibida: $event');
    GetIt.I<EmergenciaBloc>().add(GetEmergenciaAllEvent());
  });

  /*
  //para mandar una notificacion local
  final NotificationService _notificationService = NotificationService();
  await _notificationService.initNotification();
  // Para llamar la notificación en cualquier botón u evento:
  _notificationService.showNotification(
    title: '¡Hola desde Flutter!',
    body: 'Esta es una notificación local sin usar Firebase.',
  );*/

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
        BlocProvider<DbBloc>(lazy: false, create: (context) => DbBloc()),
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
                BlocProvider.value(
                  value: GetIt.I<EmergenciaBloc>()
                    ..add(GetEmergenciaAllEvent()),
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
                BlocProvider.value(value: GetIt.I<EmergenciaBloc>()),
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
