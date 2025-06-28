import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/core/utils/app_colors.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';
import 'package:vive_huanchaco/presentation/places/bloc/place_bloc.dart';

class CategoryPlacesScreen extends StatefulWidget {
  final String category;
  const CategoryPlacesScreen({required this.category, super.key});

  @override
  State<CategoryPlacesScreen> createState() => _CategoryPlacesScreenState();
}

class _CategoryPlacesScreenState extends State<CategoryPlacesScreen> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Solicitar los lugares de la categoría específica al iniciar la pantalla
    context.read<PlaceBloc>().add(GetPlacesByCategoryEvent(category: widget.category));
  }

  void _updateMarkers(List<Place> places) {
    if (places.isEmpty) return;
    setState(() {
      _markers.clear();
      for (final place in places) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: place.location,
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.address,
            ),
          ),
        );
      }
    });

    // Mover la cámara para que se ajuste a los marcadores
    if (_mapController != null && places.isNotEmpty) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_createBounds(places), 50.0),
      );
    }
  }

  LatLngBounds _createBounds(List<Place> places) {
    final lats = places.map((p) => p.location.latitude);
    final lngs = places.map((p) => p.location.longitude);
    return LatLngBounds(
      southwest: LatLng(lats.reduce((a, b) => a < b ? a : b), lngs.reduce((a, b) => a < b ? a : b)),
      northeast: LatLng(lats.reduce((a, b) => a > b ? a : b), lngs.reduce((a, b) => a > b ? a : b)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state is PlacesLoaded) {
          _updateMarkers(state.places);
        } else if (state is PlaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar lugares: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final places = (state is PlacesLoaded) ? state.places : <Place>[];
        return Column(
          children: [
            // --- MAPA INTERACTIVO (50% de la pantalla) ---
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-8.086389, -79.124167), // Huanchaco
                  zoom: 13,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (places.isNotEmpty) {
                    _updateMarkers(places);
                  }
                },
                markers: _markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
            // --- BARRA DE BÚSQUEDA Y FILTROS ---
            _buildSearchAndFilterBar(),
            // --- LISTA DE LUGARES ---
            Expanded(
              child: (state is PlaceLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPlacesList(places),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar en esta área...',
                  border: InputBorder.none,
                ),
                // La lógica de búsqueda se implementaría aquí
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Aquí se mostraría el modal o la vista de filtros
                print('Mostrar filtros');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList(List<Place> places) {
    if (places.isEmpty) {
      return const Center(
        child: Text('No se encontraron lugares en esta categoría.'),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: place.imageUrl != null
                ? Image.network(
                    place.imageUrl!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  )
                : const Icon(Icons.image, size: 50),
            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      place.rating?.toStringAsFixed(1) ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
                Text(place.address ?? 'Dirección no disponible'),
              ],
            ),
            onTap: () {
              // Redirigir a la pantalla de detalles (Módulo 5)
              print('Ir a los detalles de ${place.name}');
            },
          ),
        );
      },
    );
  }
}