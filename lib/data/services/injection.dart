import 'package:get_it/get_it.dart';
import 'package:controlbomberos/ui/emergencia/bloc/emergencia_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<EmergenciaBloc>(() => EmergenciaBloc());

  // otros repositorios y blocs...
}
