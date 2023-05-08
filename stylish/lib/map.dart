import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'dart:math' as math;
import 'dart:async';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  LatLng branchAPosition = LatLng(25.033408, 121.564099);
  LatLng branchBPosition = LatLng(24.9988551, 121.5810585);

  final Map<String, Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      final branchAMarker = Marker(
        markerId: MarkerId("taipei101"),
        position: LatLng(25.033408, 121.564099),
        infoWindow: InfoWindow(
          title: "Taipei 101",
          snippet: "台北市信義區市府路45 號",
        ),
      );

      _markers["taipei101"] = branchAMarker;

      final branchBMarker = Marker(
        markerId: MarkerId("zoo"),
        position: LatLng(24.9988551, 121.5810585),
        infoWindow: InfoWindow(
          title: "Zoo",
          snippet: "台北市信義區市府路45 號",
        ),
      );

      _markers["zoo"] = branchBMarker;

      _fitMarkersOnScreen();
    });
  }

  Future<void> _fitMarkersOnScreen() async {
    GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        math.min(branchAPosition.latitude, branchBPosition.latitude),
        math.min(branchAPosition.longitude, branchBPosition.longitude),
      ),
      northeast: LatLng(
        math.max(branchAPosition.latitude, branchBPosition.latitude),
        math.max(branchAPosition.longitude, branchBPosition.longitude),
      ),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    controller.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: Image(image: AssetImage('assets/bar_image.png')),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(25.02, 121.57),
          zoom: 12,
        ),
        markers: _markers.values.toSet(),
        myLocationEnabled: true, // Add this line
        myLocationButtonEnabled: true, // Add this line
      ),
    );
  }
}
