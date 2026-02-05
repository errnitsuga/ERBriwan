import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReceiverMapPage extends StatelessWidget {
  const ReceiverMapPage({super.key});

  static const _initial = CameraPosition(
    target: LatLng(14.5995, 120.9842), // Manila default for mock
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: _initial,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }
}

