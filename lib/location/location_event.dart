part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class NewLocation extends LocationEvent {
  final LatLng location;
  const NewLocation(this.location);
}
