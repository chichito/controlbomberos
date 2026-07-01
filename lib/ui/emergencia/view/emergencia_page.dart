import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/emergencia_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/retroalimentacion_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/tiempos_bloc.dart';
import 'package:controlbomberos/ui/emergencia/widgets/menuflotante_emergencia.dart';
import 'package:controlbomberos/ui/emergencia/widgets/tiempos_emergencia.dart';
import 'package:controlbomberos/ui/map/map_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmergenciaPage extends StatefulWidget {
  const EmergenciaPage({super.key});

  @override
  State<EmergenciaPage> createState() => _EmergenciaPageState();
}

class _EmergenciaPageState extends State<EmergenciaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final idEmer = ModalRoute.of(context)!.settings.arguments as String;

      final authState = context.read<AuthBloc>().state;
      final cedula = authState is AuthStateLoggedIn
          ? authState.user.cedula ?? ''
          : '';

      // 1. Instanciar el BLoC y lanzar el primer evento
      final miBloc = context.read<TiemposBloc>();
      miBloc.add(GetTiemposAllEvent(idEmergencia: idEmer, idUsuario: cedula));

      miBloc.stream.firstWhere((state) => state is TiemposLoaded).then((state) {
        if (mounted) {
          if ((state as TiemposLoaded).tiempos?.fechahoraasigno == null) {
            context.read<TiemposBloc>().add(
              SetTiemposAllEvent(
                idEmergencia: idEmer,
                idUsuario: cedula,
                sTipo: 'TR',
              ),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final idEmer = ModalRoute.of(context)!.settings.arguments as String;
    final authState = context.read<AuthBloc>().state;
    final cedula = authState is AuthStateLoggedIn
        ? authState.user.cedula ?? ''
        : '';
    final blocEmer = context.read<EmergenciaBloc>();
    blocEmer.add(GetEmergenciaIDEvent(idEmergencia: idEmer));

    //final tiempoState = context.read<TiemposBloc>().state;
    //final tiempos = tiempoState is TiemposLoaded ? tiempoState.tiempos : null;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<EmergenciaBloc, EmergenciaState>(
          builder: (context, state) {
            if (state is EmergenciaFailed) {
              return AppBar(title: const Text('Error'));
            }
            if (state is EmergenciaIDLoaded) {
              final title = state.emergencia?.name ?? 'Emergencia';
              return AppBar(title: Text(title));
            }
            return AppBar(title: const Text('Error'));
          },
        ),
      ),
      body: Stack(
        children: [
          BlocConsumer<EmergenciaBloc, EmergenciaState>(
            listener: (context, state) {
              if (state is EmergenciaIDLoaded) {
                context.read<RetroalimentacionBloc>().add(
                  GetRetroalimentacionEvent(
                    idEmergencia: idEmer,
                    idUsuario: cedula,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is EmergenciaFailed) {
                return Column(
                  children: [
                    Text(
                      'Error: ${state.toString()}',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    CircularProgressIndicator.adaptive(),
                  ],
                );
              }
              if (state is EmergenciaIDLoaded) {
                return SafeArea(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descripción:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: state.emergencia?.description,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              'Dirección:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text('${state.emergencia?.direccion}'),
                            Text(
                              'Referencia:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text('${state.emergencia?.referencia}'),
                          ],
                        ),
                      ),
                      Container(
                        color: state.emergencia?.estado == "PROCESANDO"
                            ? Colors.yellow
                            : state.emergencia?.estado == "FINALIZADO"
                            ? Colors.green
                            : Colors.red,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Estado: ${state.emergencia?.estado ?? 'PENDIENTE'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ' F.H.: ${state.emergencia?.fechahoraregistro?.year}-${state.emergencia?.fechahoraregistro?.month.toString().padLeft(2, '0')}-${state.emergencia?.fechahoraregistro?.day.toString().padLeft(2, '0')} ${state.emergencia?.fechahoraregistro?.hour.toString().padLeft(2, '0')}:${state.emergencia?.fechahoraregistro?.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.greenAccent,
                          width: MediaQuery.of(context).size.width,
                          child:
                              BlocBuilder<
                                RetroalimentacionBloc,
                                RetroalimentacionState
                              >(
                                builder: (context, state) {
                                  if (state is RetroalimentacionInitial) {
                                    return Text(
                                      'Loading retoalimentaciones...',
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }
                                  if (state is RetroalimentacionFailed) {
                                    return Text(
                                      'Error: Failed to load retoalimentaciones',
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }
                                  if (state is RetroalimentacionLoaded) {
                                    if (state.retroalimentacion.isEmpty) {
                                      return Text(
                                        'Sin Retoalimentaciones',
                                        style: TextStyle(color: Colors.black),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.retroalimentacion.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final retro =
                                                state.retroalimentacion[index];
                                            return Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Material(
                                                elevation: 4.0,
                                                shadowColor: Colors.black
                                                    .withValues(alpha: 0.9),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: ListTile(
                                                  title: Text(
                                                    ' F.H.: ${retro.fechahoraregistro.year}-${retro.fechahoraregistro.month.toString().padLeft(2, '0')}-${retro.fechahoraregistro.day.toString().padLeft(2, '0')} ${retro.fechahoraregistro.hour.toString().padLeft(2, '0')}:${retro.fechahoraregistro.minute.toString().padLeft(2, '0')}',
                                                  ),
                                                  subtitle: Text(
                                                    retro.comentario,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    );
                                  }
                                  return Text(
                                    'Unknown state',
                                    style: TextStyle(color: Colors.black),
                                  );
                                },
                              ),
                        ),
                      ),
                      // Bottom item acting like a sticky footer until content overflows
                      Container(
                        height: 150,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<TiemposBloc, TiemposState>(
            builder: (context, state) {
              if (state is TiemposLoaded && state.tiempos != null) {
                return MenuflotanteEmergencia(tiempo: state.tiempos!);
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<TiemposBloc, TiemposState>(
            builder: (context, state) {
              if (state is TiemposLoaded && state.tiempos != null) {
                return TiemposEmergencia(tiempo: state.tiempos!);
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            top: 1,
            right: 1,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return MapHome();
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(1), // Espacio alrededor del icono
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo del círculo
                  shape: BoxShape.circle, // Hace que el contenedor sea redondo
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2), // Sombra ligera
                    ),
                  ],
                ),
                child: Icon(Icons.location_on, color: Colors.red, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
