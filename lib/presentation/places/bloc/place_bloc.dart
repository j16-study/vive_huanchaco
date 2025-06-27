// vive_huanchaco/lib/features/places/presentation/bloc/place_bloc.dart
/*import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package.com.example.vive_huanchaco.core.usecases.usecase.NoParams; // Asegúrate de importar NoParams
import 'package.com.example.vive_huanchaco.features.places.domain.entities.place.Place; // Asegúrate de importar Place
import 'package.com.example.vive_huanchaco.features.places.domain.usecases.add_place_usecase.AddPlaceUseCase; // Asegúrate de importar AddPlaceUseCase
import 'package.com.example.vive_huanchaco.features.places.domain.usecases.get_places_by_category_usecase.GetPlacesByCategoryParams; // Asegúrate de importar GetPlacesByCategoryParams
import 'package.com.example.vive_huanchaco.features.places.domain.usecases.get_places_by_category_usecase.GetPlacesByCategoryUseCase; // Asegúrate de importar GetPlacesByCategoryUseCase
import 'package.com.example.vive_huanchaco.features.places.domain.usecases.get_places_usecase.GetPlacesUseCase; // Asegúrate de importar GetPlacesUseCase
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart'; // Asegúrate de importar Place
import 'package:vive_huanchaco/domain/places/usecases/add_place_usecase.dart'; // Asegúrate de importar AddPlaceUseCase
import 'package:vive_huanchaco/domain/places/usecases/get_places_by_category_usecase.dart'; // Asegúrate de importar GetPlacesByCategoryUseCase
import 'package:vive_huanchaco/domain/places/usecases/get_places_usecase.dart'; // Asegúrate de importar GetPlacesUseCase


part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GetPlacesUseCase getPlacesUseCase;
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;
  final AddPlaceUseCase addPlaceUseCase;

  PlaceBloc({
    required this.getPlacesUseCase,
    required this.getPlacesByCategoryUseCase,
    required this.addPlaceUseCase,
  }) : super(PlaceInitial()) {
    on<GetPlacesEvent>(_onGetPlaces);
    on<GetPlacesByCategoryEvent>(_onGetPlacesByCategory);
    on<AddPlaceEvent>(_onAddPlace);
  }

  Future<void> _onGetPlaces(GetPlacesEvent event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    final failureOrPlaces = await getPlacesUseCase(NoParams());
    failureOrPlaces.fold(
      (failure) => emit(PlaceError(message: failure.message)),
      (places) => emit(PlacesLoaded(places: places)),
    );
  }

  Future<void> _onGetPlacesByCategory(GetPlacesByCategoryEvent event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    final failureOrPlaces = await getPlacesByCategoryUseCase(GetPlacesByCategoryParams(category: event.category));
    failureOrPlaces.fold(
      (failure) => emit(PlaceError(message: failure.message)),
      (places) => emit(PlacesLoaded(places: places)),
    );
  }

  Future<void> _onAddPlace(AddPlaceEvent event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    final failureOrPlace = await addPlaceUseCase(AddPlaceParams(place: event.place));
    failureOrPlace.fold(
      (failure) => emit(PlaceError(message: failure.message)),
      (place) => emit(PlaceAdded(place: place)),
    );
  }
}