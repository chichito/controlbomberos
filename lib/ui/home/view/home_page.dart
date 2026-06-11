import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/core/navigation/app_navigator.dart';
import 'package:controlbomberos/ui/core/widgets/globo_avatar.dart';
import 'package:controlbomberos/ui/emergencia/bloc/emergencia_bloc.dart';
import 'package:controlbomberos/ui/emergencia/widgets/item_emergencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthStateLoggedIn ? authState.user : null;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.red[10],
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.blueAccent,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome ${user?.name}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            //Navigator.pushNamed(context, AppNavigator.profile);
                          },
                          child: GloboAvatar(name: user?.name ?? ''),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: BlocBuilder<EmergenciaBloc, EmergenciaState>(
                        builder: (context, state) {
                          if (state is EmergenciaInitial) {
                            return Text(
                              'Loading emergencias...',
                              style: TextStyle(color: Colors.black),
                            );
                          }
                          if (state is EmergenciaFailed) {
                            return Text(
                              'Error: Failed to load emergencias',
                              style: TextStyle(color: Colors.black),
                            );
                          }
                          if (state is EmergenciaLoaded) {
                            return ListView.builder(
                              itemCount: state.emergencias.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppNavigator.emergencia,
                                      arguments: state.emergencias[index],
                                    );
                                  },
                                  child: ItemEmergencia(
                                    emergencia: state.emergencias[index],
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
