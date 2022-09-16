part of 'location_bloc.dart';

class LocationState extends Equatable {
  LocationState({this.location});

  final LatLng? location;

  LocationState copyWith({
    LatLng? location,
  }) =>
      LocationState(location: location ?? this.location);

  @override
  List<Object?> get props => [location];
}
