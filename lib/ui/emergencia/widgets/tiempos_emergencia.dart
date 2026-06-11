import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:flutter/material.dart';

class TiemposEmergencia extends StatelessWidget {
  const TiemposEmergencia({super.key, required this.tiempo});
  final Tiempo tiempo;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      left: 20.0,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.transparent, // Makes the base background transparent
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiempos de la Emergencia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Num Vistas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        tiempo.numerorevisado.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'F Reviso',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${tiempo.fechahorareviso?.year}-${tiempo.fechahorareviso?.month.toString().padLeft(2, '0')}-${tiempo.fechahorareviso?.day.toString().padLeft(2, '0')} ${tiempo.fechahorareviso?.hour.toString().padLeft(2, '0')}:${tiempo.fechahorareviso?.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        'F Asigno',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (tiempo.fechahoraasigno != null)
                        Text(
                          '${tiempo.fechahoraasigno!.year}-${tiempo.fechahoraasigno!.month.toString().padLeft(2, '0')}-${tiempo.fechahoraasigno!.day.toString().padLeft(2, '0')} ${tiempo.fechahoraasigno!.hour.toString().padLeft(2, '0')}:${tiempo.fechahoraasigno!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      else
                        Text(
                          'Sin asignar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'F Sitio',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (tiempo.fechahorasitio != null)
                        Text(
                          '${tiempo.fechahorasitio!.year}-${tiempo.fechahorasitio!.month.toString().padLeft(2, '0')}-${tiempo.fechahorasitio!.day.toString().padLeft(2, '0')} ${tiempo.fechahorasitio!.hour.toString().padLeft(2, '0')}:${tiempo.fechahorasitio!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      else
                        Text(
                          'Sin llegar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'F Retorno',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (tiempo.fechahoraretorno != null)
                        Text(
                          '${tiempo.fechahoraretorno!.year}-${tiempo.fechahoraretorno!.month.toString().padLeft(2, '0')}-${tiempo.fechahoraretorno!.day.toString().padLeft(2, '0')} ${tiempo.fechahoraretorno!.hour.toString().padLeft(2, '0')}:${tiempo.fechahoraretorno!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      else
                        Text(
                          'aun en sitio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'F Finalizo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (tiempo.fechahorafinalizo != null)
                        Text(
                          '${tiempo.fechahorafinalizo!.year}-${tiempo.fechahorafinalizo!.month.toString().padLeft(2, '0')}-${tiempo.fechahorafinalizo!.day.toString().padLeft(2, '0')} ${tiempo.fechahorafinalizo!.hour.toString().padLeft(2, '0')}:${tiempo.fechahorafinalizo!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      else
                        Text(
                          'sin finalizar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
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
