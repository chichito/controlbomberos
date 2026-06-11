import 'package:controlbomberos/db/bloc/db_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  void initState() {
    super.initState();
    //context.read<DbBloc>().add(DBInitialStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Bienvenido a la página de inicio'),
            Center(
              child: BlocBuilder<DbBloc, DbState>(
                builder: (context, state) {
                  if (state is DBInitialStatusState) {
                    return Column(
                      children: [
                        Text(
                          'Conectando a la base de datos...',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  } else if (state is DBConnectedState) {
                    return Text('Base de datos conectada');
                  } else if (state is DBErrorState) {
                    return Column(
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Text('Sistema de control de bomberos'),
          ],
        ),
      ),
    );
  }
}
