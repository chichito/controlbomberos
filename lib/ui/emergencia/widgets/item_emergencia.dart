import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:flutter/material.dart';

class ItemEmergencia extends StatelessWidget {
  const ItemEmergencia({super.key, required this.emergencia});
  final Emergencia emergencia;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emergencia.name ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(emergencia.description ?? ''),
                SizedBox(height: 4),
                Text('Dirección: ${emergencia.direccion}'),
                SizedBox(height: 4),
                Text('Referencia: ${emergencia.referencia}'),
              ],
            ),

            //                      'F: ${emergencia.fechahoraregistro?.year}-${emergencia.fechahoraregistro?.month.toString().padLeft(2, '0')}-${emergencia.fechahoraregistro?.day.toString().padLeft(2, '0')} ${emergencia.fechahoraregistro?.hour.toString().padLeft(2, '0')}:${emergencia.fechahoraregistro?.minute.toString().padLeft(2, '0')}',
            Positioned(
              bottom: 0,
              right: 0,
              child: RichText(
                text: TextSpan(
                  text: 'F: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${emergencia.fechahoraregistro?.year}-${emergencia.fechahoraregistro?.month.toString().padLeft(2, '0')}-${emergencia.fechahoraregistro?.day.toString().padLeft(2, '0')} \n',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(text: 'H: '),
                    TextSpan(
                      text:
                          '${emergencia.fechahoraregistro?.hour.toString().padLeft(2, '0')}:${emergencia.fechahoraregistro?.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: -20,
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: emergencia.estado == "PROCESANDO"
                      ? Colors.yellow
                      : emergencia.estado == "FINALIZADO"
                      ? Colors.green
                      : Colors.red,
                  shape: BoxShape.circle, // Hace el contenedor circular
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(
                        0,
                        3,
                      ), // Efecto de flotado (sombra hacia abajo)
                    ),
                  ],
                ),

                child: Center(
                  child: Text(
                    emergencia.estado == "PROCESANDO"
                        ? "PR"
                        : emergencia.estado == "FINALIZADO"
                        ? "FI"
                        : "PE",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


      /*child: ListTile(
        title: Text(emergencia.name ?? ''),
        subtitle: Text(emergencia.description ?? ''),
        trailing: Text(emergencia.fechahoraregistro?.toString() ?? ''),
    );*/