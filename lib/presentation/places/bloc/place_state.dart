// vive_huanchaco/lib/features/places/presentation/bloc/place_state.dart
part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlacesLoaded extends PlaceState {
  final List<Place> places;

  const PlacesLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

class PlaceError extends PlaceState {
  final String message;

  const PlaceError({required this.message});

  @override
  List<Object> get props => [message];
}

class PlaceAdded extends PlaceState {
  final Place place;

  const PlaceAdded({required this.place});

  @override
  List<Object> get props => [place];
}