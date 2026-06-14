import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/emergencia/bloc/retroalimentacion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IngcometariosEmergencia extends StatelessWidget {
  const IngcometariosEmergencia({
    super.key,
    required this.idEmergencia,
    required this.sTipoTiempo,
  });
  final String idEmergencia;
  final String sTipoTiempo;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: size.width * 0.90,
            height: size.height * 0.30,
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Ingreso de RetroAlimentacion Emergencia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 80, // Ajusta esta cantidad para bajar tu TextFormField
                  left: 0.0,
                  right: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200, // Ajusta la altura total de tu SizedBox
                      child: Material(
                        elevation: 10, // Control the shadow depth here
                        shadowColor: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (valor) {
                              // Añadimos el evento cada vez que el usuario teclea
                              context.read<RetroalimentacionBloc>().add(
                                TextoRetroalimentacion(valor),
                              );
                            },
                            decoration: const InputDecoration(
                              alignLabelWithHint:
                                  true, // Alinea la etiqueta arriba
                              contentPadding: EdgeInsets.only(
                                top:
                                    15.0, // <-- AUMENTA ESTE VALOR para bajar el inicio del texto
                                left: 12.0,
                                right: 12.0,
                                bottom: 12.0,
                              ),
                            ),
                            textAlignVertical: TextAlignVertical
                                .top, // Alinea el texto de entrada arriba
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocBuilder<
                        RetroalimentacionBloc,
                        RetroalimentacionState
                      >(
                        builder: (context, state) {
                          if (state is! RetroalimentacionStateGrabado) {
                            return ElevatedButton(
                              onPressed: () {
                                final authState = context
                                    .read<AuthBloc>()
                                    .state;
                                final cedula = authState is AuthStateLoggedIn
                                    ? authState.user.cedula ?? ''
                                    : '';
                                context.read<RetroalimentacionBloc>().add(
                                  SetRetroalimentacionEvent(
                                    idEmergencia: idEmergencia,
                                    idUsuario: cedula,
                                    sTipoTiempo: sTipoTiempo,
                                  ),
                                );
                              },
                              child: Text('Aceptar'),
                            );
                          }
                          final isLoading =
                              (state).status == RetroalimentacionStatus.loading;

                          return SizedBox(
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : SizedBox(
                                    width: 250,
                                    child: Text(
                                      state.message ?? 'Error',
                                      textAlign: TextAlign.center,
                                      style:
                                          state.status ==
                                              RetroalimentacionStatus.success
                                          ? TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            )
                                          : TextStyle(color: Colors.red),
                                    ),
                                  ),
                          );
                        },
                      ),

                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('salir'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
