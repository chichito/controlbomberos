import 'package:flutter/material.dart';

class MapHome extends StatelessWidget {
  const MapHome({super.key});

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
            height: size.height * 0.90,
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('Reporte'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('Salir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
