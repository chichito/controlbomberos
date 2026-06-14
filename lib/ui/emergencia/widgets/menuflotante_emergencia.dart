import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:controlbomberos/ui/emergencia/bloc/retroalimentacion_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/tiempos_bloc.dart';
import 'package:controlbomberos/ui/emergencia/widgets/ingcometarios_emergencia.dart';
import 'package:controlbomberos/ui/emergencia/widgets/ingfotosvideos_emergencia.dart';
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
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Visibility(
              visible: tiempo.fechahoraasigno != null
                  ? tiempo.fechahorafinalizo == null
                        ? true
                        : false
                  : false,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return IngfotosvideosEmergencia(
                        idEmergencia: tiempo.idemergencia ?? '',
                        sTipoTiempo: '',
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: Center(child: Text('Fotos y Videos')),
                ),
              ),
            ),
          ),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Visibility(
              visible: tiempo.fechahoraasigno != null
                  ? tiempo.fechahorafinalizo == null
                        ? true
                        : false
                  : false,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      String sTipoTemp = '';
                      if (tiempo.fechahoraasigno != null) sTipoTemp = 'TA';
                      if (tiempo.fechahorasitio != null) sTipoTemp = 'TS';
                      if (tiempo.fechahoraretorno != null) sTipoTemp = 'TRE';
                      if (tiempo.fechahorafinalizo != null) sTipoTemp = 'TF';
                      return BlocProvider(
                        create: (context) => RetroalimentacionBloc(),
                        child: IngcometariosEmergencia(
                          idEmergencia: tiempo.idemergencia ?? '',
                          sTipoTiempo: sTipoTemp,
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: Center(child: Text('Comentar')),
                ),
              ),
            ),
          ),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: tiempo.fechahoraasigno == null ? true : false,
                  child: GestureDetector(
                    onTap: () {
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TA',
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.emergency_share_sharp),
                          Text('Asignacion'),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: tiempo.fechahorasitio == null
                      ? tiempo.fechahoraasigno != null
                            ? true
                            : false
                      : false,
                  child: GestureDetector(
                    onTap: () {
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TS',
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.airport_shuttle_rounded),
                          Text('Sitio'),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: tiempo.fechahoraretorno == null
                      ? tiempo.fechahorasitio != null
                            ? true
                            : false
                      : false,
                  child: GestureDetector(
                    onTap: () {
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TRE',
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.redo_outlined), Text('Retorno')],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: tiempo.fechahorafinalizo == null
                      ? tiempo.fechahoraretorno != null
                            ? true
                            : false
                      : false,
                  child: GestureDetector(
                    onTap: () {
                      context.read<TiemposBloc>().add(
                        SetTiemposAllEvent(
                          idEmergencia: tiempo.idemergencia ?? '',
                          idUsuario: tiempo.idusuario ?? '',
                          sTipo: 'TF',
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.terminal_rounded),
                          Text('Finalizado'),
                        ],
                      ),
                    ),
                  ),
                ),
                /* PopupMenuButton<String>(
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
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
