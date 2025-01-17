import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emergency_doctors_screen.dart';
import 'emergency_service_screen.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key, required this.userId});
  final String userId;

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  Location _location = Location();
  LatLng? _currentLocation;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getLocation(); // Directly get location on init
  }

  Future<void> _getLocation() async {
    // Get the current location
    final loc = await _location.getLocation();

    setState(() {
      _currentLocation = LatLng(loc.latitude!, loc.longitude!);
    });

    // Listen for location updates
    _location.onLocationChanged.listen((newLoc) {
      if (_mapController != null) {
        _mapController.move(LatLng(newLoc.latitude!, newLoc.longitude!), 14.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              hasBackButton: true,
              backButtonBorderColor: theme.primary.withOpacity(.3),
              vPadding: 15,
              title: 'Emergency',
              textColor: theme.primary,
              textSize: 18,
              bgColor: theme.surface,
              subtitle: 'Get an emergency service',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  // Full-screen FlutterMap
                  _currentLocation == null
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCameraFit: CameraFit.insideBounds(
                          bounds: LatLngBounds(
                              _currentLocation!, _currentLocation!)),
                      initialCenter:
                      _currentLocation!, // Center the map on the current location
                      initialZoom:
                      20.0, // Adjust the zoom level as needed
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSM tile server
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        // Add MarkerLayer for current location
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _currentLocation!,
                            // Use the child parameter instead of builder
                            child: Container(
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () => launchUrl(Uri.parse(
                                'https://openstreetmap.org/copyright')), // (external)
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Container at the bottom with rounded corners at the top
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 205, // Height of the bottom container
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.local_hospital,
                                  color: theme.primary),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmergencyService(
                                          userId: widget.userId,
                                          currentLocation:
                                          _currentLocation!,
                                        )));
                              },
                              title: Text('Emergency Services',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Get emergency services like ambulance, fire, etc. Available 24/7'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.call, color: theme.primary),
                              title: Text('Emergency doctor',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Call an emergency doctor. Available 24/7'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmergencyDoctorPage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}