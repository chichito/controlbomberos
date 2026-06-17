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
    //final retroBloc = context.read<RetroalimentacionBloc>();
    final size = MediaQuery.of(context).size;

    return BlocConsumer<RetroalimentacionBloc, RetroalimentacionState>(
      listener: (context, state) {
        if (state is RetroalimentacionStateGrabado) {
          switch (state.status) {
            case RetroalimentacionStatus.success:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Guardado')),
              );
              Navigator.pop(context, true);
              break;

            case RetroalimentacionStatus.error:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message ?? 'Error')));
              break;

            default:
              break;
          }
        }
      },
      builder: (context, state) {
        final isLoading =
            state is RetroalimentacionStateGrabado &&
            state.status == RetroalimentacionStatus.loading;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      top:
                          80, // Ajusta esta cantidad para bajar tu TextFormField
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final authState = context
                                            .read<AuthBloc>()
                                            .state;
                                        final cedula =
                                            authState is AuthStateLoggedIn
                                            ? authState.user.cedula ?? ''
                                            : '';
                                        context
                                            .read<RetroalimentacionBloc>()
                                            .add(
                                              SetRetroalimentacionEvent(
                                                idEmergencia: idEmergencia,
                                                idUsuario: cedula,
                                                sTipoTiempo: sTipoTiempo,
                                              ),
                                            );
                                      },
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Aceptar'),
                              ),
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: Text('salir'),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isLoading
                                ? ''
                                : (state is RetroalimentacionStateGrabado)
                                ? (state).status ==
                                          RetroalimentacionStatus.error
                                      ? (state).message ?? ''
                                      : (state).status ==
                                            RetroalimentacionStatus.empty
                                      ? (state).message ?? ''
                                      : ''
                                : '',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
      },
    );
  }
}
