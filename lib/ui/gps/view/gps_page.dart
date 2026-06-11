import 'package:controlbomberos/ui/gps/bloc/gps_bloc.dart';
import 'package:controlbomberos/ui/gps/widgets/enable_gps.dart';
import 'package:controlbomberos/ui/gps/widgets/permissions_gps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GpsPage extends StatelessWidget {
  const GpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPS')),
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          if (state.isGpsEnabled) {
            return const PermissionsGps();
          }
          return const EnableGps();
        },
      ),
    );
  }
}
