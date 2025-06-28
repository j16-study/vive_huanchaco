part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class GetPlacesEvent extends PlaceEvent {}

class GetPlacesByCategoryEvent extends PlaceEvent {
  final String category;

  const GetPlacesByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class AddPlaceEvent extends PlaceEvent {
  final Place place;

  const AddPlaceEvent({required this.place});

  @override
  List<Object> get props => [place];
}