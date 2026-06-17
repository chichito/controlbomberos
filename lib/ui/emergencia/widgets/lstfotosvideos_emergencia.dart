import 'package:controlbomberos/ui/auth/bloc/auth_bloc.dart';
import 'package:controlbomberos/ui/emergencia/widgets/videoitemwidget.dart';
import 'package:controlbomberos/ui/fotosvideos/bloc/fotosvideos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LstfotosvideosEmergencia extends StatefulWidget {
  const LstfotosvideosEmergencia({
    super.key,
    required this.idEmergencia,
    required this.sTipoTiempo,
  });
  final String idEmergencia;
  final String sTipoTiempo;

  @override
  State<LstfotosvideosEmergencia> createState() =>
      _LstfotosvideosEmergenciaState();
}

class _LstfotosvideosEmergenciaState extends State<LstfotosvideosEmergencia> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authState = context.read<AuthBloc>().state;
      final cedula = authState is AuthStateLoggedIn
          ? authState.user.cedula ?? ''
          : '';

      context.read<FotosVideosBloc>().add(
        GetPickEvent(idUsuario: cedula, idEmergencia: widget.idEmergencia),
      );
    });
  }

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
            height: size.height * 0.60,
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
            child: BlocBuilder<FotosVideosBloc, FotosVideosState>(
              builder: (context, state) {
                final isLoading = state.status == FotosVideosStatus.loading;
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Elegir Fotos Emergencia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            final fotosVideosBloc = context
                                .read<FotosVideosBloc>();
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return BlocProvider.value(
                                  value: fotosVideosBloc,
                                  child: const ItemBotonesElegirDos(),
                                );
                              },
                            );

                            /*
                                        final fotosVideosBloc =
                                            BlocProvider.of<FotosvideosBloc>(context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return BlocProvider.value(
                                              value: fotosVideosBloc,
                                              child: ItemBotonesElegir(size: size),
                                            );
                                          },
                                        );
                                        */
                          },
                          child: Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          30, // Ajusta esta cantidad para bajar tu TextFormField
                      left: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                          child: state.media.isEmpty
                              ? Center(
                                  child: Text('No hay Imagenes Seleccionadas'),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                      ),
                                  itemCount: state.media.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            state.media[index].tipo == 'imagen'
                                                ? Image.memory(
                                                    state.media[index].file!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : VideoItemWidget(
                                                    videoBytes: state
                                                        .media[index]
                                                        .file!,
                                                  ),
                                            Positioned(
                                              right: 5,
                                              top: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<FotosVideosBloc>()
                                                      .add(
                                                        PickDeleteMediaEvent(
                                                          index: index,
                                                        ),
                                                      );
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 12,
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                ), //bulder aqui
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : state.media.isEmpty
                                      ? null
                                      : () {
                                          final authState = context
                                              .read<AuthBloc>()
                                              .state;
                                          final cedula =
                                              authState is AuthStateLoggedIn
                                              ? authState.user.cedula ?? ''
                                              : '';
                                          context.read<FotosVideosBloc>().add(
                                            SendPickEvent(
                                              idEmergencia: widget.idEmergencia,
                                              idUsuario: cedula,
                                              sTipoTiempo: widget.sTipoTiempo,
                                            ),
                                          );
                                        },
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Grabar'),
                                ),
                              ),
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: Text('Salir'),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isLoading
                                ? ''
                                : (state).status == FotosVideosStatus.error
                                ? (state).message ?? ''
                                : (state).status == FotosVideosStatus.empty
                                ? (state).message ?? ''
                                : (state).status == FotosVideosStatus.success
                                ? (state).message ?? ''
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemBotonesElegirDos extends StatelessWidget {
  const ItemBotonesElegirDos({super.key});

  @override
  Widget build(BuildContext context) {
    final fotosVideosBloc = context.read<FotosVideosBloc>();
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galería'),
            onTap: () {
              fotosVideosBloc.add(PickMultipleMediaFromGalleryEvent());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara Foto'),
            onTap: () {
              fotosVideosBloc.add(PickImagesFromCameraEvent());
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara Video'),
            onTap: () {
              fotosVideosBloc.add(PickVideosFromCameraEvent());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

/*no se utliza por que se utiliza otro metodo*/
class ItemBotonesElegirUno extends StatelessWidget {
  const ItemBotonesElegirUno({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final aa = context.read<FotosVideosBloc>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: size.width * 0.60,
            height: size.height * 0.15,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    aa.add(PickMultipleMediaFromGalleryEvent());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Galería'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<FotosVideosBloc>().add(
                      PickImagesFromCameraEvent(),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Cámara'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
