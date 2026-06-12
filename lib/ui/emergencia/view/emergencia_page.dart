import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/emergencia_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/tiempos_bloc.dart';
import 'package:controlbomberos/ui/emergencia/widgets/menuflotante_emergencia.dart';
import 'package:controlbomberos/ui/emergencia/widgets/tiempos_emergencia.dart';
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
          BlocBuilder<EmergenciaBloc, EmergenciaState>(
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
                return Column(
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
                  ],
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
        ],
      ),
    );
  }
}
