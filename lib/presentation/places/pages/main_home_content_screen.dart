// vive_huanchaco/lib/features/places/presentation/pages/main_home_content_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:Maps_flutter/Maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/presentation/places/bloc/place_bloc.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';
import 'package:geolocator/geolocator.dart'; // Para obtener la ubicación actual

class MainHomeContentScreen extends StatefulWidget {
  const MainHomeContentScreen({super.key});

  @override
  State<MainHomeContentScreen> createState() => _MainHomeContentScreenState();
}

class _MainHomeContentScreenState extends State<MainHomeContentScreen> {
  GoogleMapController? mapController;
  // Puedes establecer una ubicación inicial predeterminada, por ejemplo, Huanchaco
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-8.086389, -79.124167), // Coordenadas de Huanchaco
    zoom: 14.0,
  );
  final Set<Marker> _markers = {};
  LatLng? _currentLocation; // Para almacenar la ubicación actual del usuario

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Intenta obtener la ubicación del usuario
    // Despacha el evento para cargar los lugares al inicio
    context.read<PlaceBloc>().add(GetPlacesEvent());
  }

  // Método para solicitar y obtener la posición actual del usuario
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los servicios de ubicación están deshabilitados.')),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permisos de ubicación denegados.')),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los permisos de ubicación están permanentemente denegados. Por favor, habilítalos desde la configuración del dispositivo.')),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Cuando llegamos aquí, los permisos están concedidos y podemos obtener la posición.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        // Añade un marcador para la ubicación actual
        _addMarker(
          markerId: 'current_location',
          position: _currentLocation!,
          title: 'Mi Ubicación Actual',
          snippet: 'Estoy aquí',
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
        // Mueve la cámara al lugar actual del usuario si el mapa ya está listo
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(_currentLocation!),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo obtener la ubicación actual: $e')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Si ya tenemos la ubicación actual, mover la cámara a ella
    if (_currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  void _addMarker({
    required String markerId,
    required LatLng position,
    required String title,
    String? snippet,
    BitmapDescriptor? icon,
  }) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: icon ?? BitmapDescriptor.defaultMarker,
    );
    // Usamos addAll para asegurar que si ya hay un marcador con el mismo ID, se actualice.
    // Opcionalmente, puedes limpiar _markers.clear() antes de agregar todos los nuevos.
    setState(() {
      // Eliminar el marcador anterior de ubicación actual si existe antes de añadir uno nuevo.
      if (markerId == 'current_location') {
        _markers.removeWhere((m) => m.markerId.value == 'current_location');
      }
      _markers.add(marker);
    });
  }

  void _addPlaceMarkers(List<Place> places) {
    setState(() {
      // Opcional: _markers.clear(); si quieres remover todos los marcadores excepto la ubicación del usuario
      // Mantenemos los marcadores existentes y solo agregamos/actualizamos los de lugares
      for (var place in places) {
        _addMarker(
          markerId: place.id,
          position: place.location,
          title: place.name,
          snippet: place.description,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Marcador rojo para lugares turísticos
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state is PlacesLoaded) {
          _addPlaceMarkers(state.places);
        } else if (state is PlaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar lugares: ${state.message}')),
          );
        } else if (state is PlaceAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lugar "${state.place.name}" añadido con éxito!')),
          );
          // Opcional: Si deseas recargar todos los lugares después de añadir uno
          // context.read<PlaceBloc>().add(GetPlacesEvent());
        }
      },
      builder: (context, state) {
        // Podrías mostrar un indicador de carga si el estado es PlaceLoading
        // aunque GoogleMap ya tiene un indicador interno si no tiene datos.
        return Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _kInitialPosition,
              markers: _markers,
              myLocationEnabled: true, // Habilita el punto azul de ubicación del usuario
              myLocationButtonEnabled: true, // Habilita el botón para ir a mi ubicación
              zoomControlsEnabled: true, // Controladores de zoom en el mapa
            ),
            // Ejemplo de botón flotante para añadir un lugar (solo para pruebas)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  // Este es un ejemplo. En una app real, aquí lanzarías un formulario.
                  final newPlace = Place(
                    id: DateTime.now().millisecondsSinceEpoch.toString(), // Firestore generará uno real
                    name: 'Nuevo Lugar de Prueba',
                    description: 'Un lugar creado desde el FAB.',
                    category: 'Test',
                    location: const LatLng(-8.086389, -79.124167), // Ubicación de ejemplo
                    rating: 5.0,
                    imageUrl: 'https://via.placeholder.com/150',
                    address: 'Calle Falsa 123, Huanchaco',
                    phoneNumber: '123456789',
                    website: 'http://example.com',
                  );
                  context.read<PlaceBloc>().add(AddPlaceEvent(place: newPlace));
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.add_location_alt),
              ),
            ),
            if (state is PlaceLoading)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}