import 'dart:io';

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
  // Muestra un menú inferior (Modal) para elegir opción
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  context.read<FotosvideosBloc>().add(
                    PickImagesFromGalleryEvent(),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () {
                  context.read<FotosvideosBloc>().add(
                    PickImagesFromCameraEvent(),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Galeria de Fotos Emergencia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
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
                      height: 200,
                      child: BlocBuilder<FotosvideosBloc, FotosvideosState>(
                        builder: (context, state) {
                          if (state.images.isEmpty) {
                            return Center(
                              child: Text('No hay Imagenes Seleccionadas'),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                            itemCount: state.images.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(state.images[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        /*setState(() {
                                                                  _imageFiles.removeAt(index);
                                                                });*/
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
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            final fotosVideosBloc =
                                BlocProvider.of<FotosvideosBloc>(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BlocProvider.value(
                                  value: fotosVideosBloc,
                                  child: ItemBotonesGaleriaCamara(size: size),
                                );
                              },
                            );
                          },
                          child: Icon(Icons.add_a_photo),
                        ),
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

class ItemBotonesGaleriaCamara extends StatelessWidget {
  const ItemBotonesGaleriaCamara({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final aa = context.read<FotosvideosBloc>();
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
                    aa.add(PickImagesFromGalleryEvent());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Galería'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<FotosvideosBloc>().add(
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
