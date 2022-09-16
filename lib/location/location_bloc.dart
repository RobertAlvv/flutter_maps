import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? locationSubscription;
  MapController? controller;

  LocationBloc() : super(LocationState()) {
    on<NewLocation>(
        (event, emit) => emit(state.copyWith(location: event.location)));
  }

  void onStartingFollowing(MapController controller) {
    this.controller = controller;

    locationSubscription = Geolocator.getPositionStream().listen((event) {
      final location = LatLng(event.latitude, event.longitude);
      this.controller!.move(location, 17);
      add(NewLocation(location));
    });
  }
}
