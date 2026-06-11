import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:controlbomberos/ui/emergencia/bloc/tiempos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuflotanteEmergencia extends StatelessWidget {
  const MenuflotanteEmergencia({super.key, required this.tiempo});
  final Tiempo tiempo;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      right: 20.0,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: tiempo.fechahoraasigno == null ? true : false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emergency_share_sharp),
                    onPressed: () {
                      // Acción de Asignacion
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TA',
                        ),
                      );
                    },
                  ),
                  Text('Asignacion'),
                ],
              ),
            ),
            Visibility(
              visible: tiempo.fechahorasitio == null
                  ? tiempo.fechahoraasigno != null
                        ? true
                        : false
                  : false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.airport_shuttle_rounded),
                    onPressed: () {
                      // Sitio
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TS',
                        ),
                      );
                    },
                  ),
                  Text('Sitio'),
                ],
              ),
            ),
            Visibility(
              visible: tiempo.fechahoraretorno == null
                  ? tiempo.fechahorasitio != null
                        ? true
                        : false
                  : false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.redo_outlined),
                    onPressed: () {
                      // Retorno
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TRE',
                        ),
                      );
                    },
                  ),
                  Text('Retorno'),
                ],
              ),
            ),
            Visibility(
              visible: tiempo.fechahorafinalizo == null
                  ? tiempo.fechahoraretorno != null
                        ? true
                        : false
                  : false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.terminal_rounded),
                    onPressed: () {
                      // finalizado
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TF',
                        ),
                      );
                    },
                  ),
                  Text('Finalizado'),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (String value) {
                // Acción del botón 3
                if (value == 'opcion_1') {
                  // Editar
                } else if (value == 'opcion_2') {
                  // Eliminar
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'opcion_1',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'opcion_2',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
