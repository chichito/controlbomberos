import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHome extends StatefulWidget {
  const MapHome({super.key});

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  // Use a FutureBuilder to safely initialize the MBTiles database file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Windows Desktop Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-2.308, -78.114), // Quito Coordinates
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.controlbomberos',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-2.308, -78.114), // Quito Coordinates
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
