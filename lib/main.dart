import 'dart:developer';

import 'package:app_maps/gps/gps_bloc.dart';
import 'package:app_maps/location/location_bloc.dart';
import 'package:app_maps/location_permission_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
      ],
      child: const MaterialApp(
        title: 'Material App',
        home: MyHome(),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            if (state.isAllGranted) {
              return MyMap();
            } else if (!state.isGpsEnabled) {
              return Container();
            } else {
              return LocationPermissionComponent();
            }
          },
        ));
  }
}

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  Widget build(BuildContext context) {
    final locationBloc = context.watch<LocationBloc>();
    return FutureBuilder<Position>(
      future: Geolocator.getCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          final location = snapshot.data;
          return BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              return FlutterMap(
                options: MapOptions(
                    zoom: 17,
                    minZoom: 12,
                    maxZoom: 18,
                    center: LatLng(location!.latitude, location.longitude),
                    onMapCreated: (controller) {
                      locationBloc.onStartingFollowing(controller);
                    }),
                nonRotatedLayers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1Ijoicm9iZXJ0YWx2YXJlejI1IiwiYSI6ImNsNnhvcG45azBxbTgzaWswa29rNWQ3cHkifQ.kOZKScU4w9_kAGeUIvDMvA',
                      'id': 'mapbox/dark-v10'
                    },
                  ),
                  MarkerLayerOptions(
                    markers: <Marker>[
                      Marker(
                          point: state.location ??
                              LatLng(location.latitude, location.longitude),
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                log("on tap");
                              },
                              child: const Icon(
                                Icons.location_on_sharp,
                                color: Colors.blue,
                                size: 40,
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
