// lib/presentation/places/pages/category_places_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/data/places/datasources/google_places_data_source.dart';
import 'package:vive_huanchaco/data/places/models/place_api_models.dart' as api; // Usamos un prefijo
import 'package:vive_huanchaco/presentation/places/widgets/filter_options_widget.dart';

class CategoryPlacesScreen extends StatefulWidget {
  final String category;
  const CategoryPlacesScreen({required this.category, super.key});

  @override
  State<CategoryPlacesScreen> createState() => _CategoryPlacesScreenState();
}

class _CategoryPlacesScreenState extends State<CategoryPlacesScreen> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  late final GooglePlacesDataSource _placesDataSource;

  List<api.Place> _places = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final api.Location _huanchacoLocation = api.Location(latitude: -8.0777, longitude: -79.1205);

  @override
  void initState() {
    super.initState();
    _placesDataSource = GooglePlacesDataSource();
    _fetchPlaces();
  }

  String _getGooglePlaceType(String category) {
    switch (category.toLowerCase()) {
      case 'museos': return 'museum';
      case 'hoteles': return 'lodging';
      case 'restaurantes': return 'restaurant';
      case 'cafeterías': return 'cafe';
      case 'parques': return 'park';
      case 'bares': return 'bar';
      case 'bancos': return 'bank';
      default: return 'tourist_attraction';
    }
  }

  Future<void> _fetchPlaces() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final placeType = _getGooglePlaceType(widget.category);
      final results = await _placesDataSource.searchNearby(placeType, _huanchacoLocation);

      if (!mounted) return;
      _updateMarkers(results);
      setState(() {
        _places = results;
      });

    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateMarkers(List<api.Place> places) {
    final newMarkers = places.map((place) {
      return Marker(
        markerId: MarkerId(place.name), // Usamos el 'name' como ID único
        position: place.latLng,
        infoWindow: InfoWindow(title: place.displayName.text),
      );
    }).toSet();
    if (mounted) setState(() => _markers.addAll(newMarkers));
  }
  
  // ... (El resto del archivo, build, _buildSearchAndFilterBar, etc. sigue abajo)

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(_huanchacoLocation.latitude, _huanchacoLocation.longitude), zoom: 14),
          onMapCreated: (controller) => _mapController = controller,
          markers: _markers,
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.5, minChildSize: 0.5, maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black26)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                  _buildSearchAndFilterBar(),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildContent(scrollController),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildContent(ScrollController scrollController) {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      );
    }
    if (_places.isEmpty) {
      return const Center(child: Text('No se encontraron lugares en esta categoría.'));
    }
    return _buildPlacesList(_places, scrollController);
  }

  Widget _buildSearchAndFilterBar() {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en ${widget.category}...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const FilterOptionsWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesList(List<api.Place> places, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final photoName = place.photos?.isNotEmpty == true ? place.photos!.first.name : null;

        return ListTile(
          leading: SizedBox(
            width: 60, height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: photoName != null
                  ? Image.network(
                      _placesDataSource.getPhotoUrl(photoName),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.business, color: Colors.grey),
                    )
                  : const Icon(Icons.business, size: 40, color: Colors.grey),
            ),
          ),
          title: Text(place.displayName.text, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.rating != null)
                Row(
                  children: [
                    Text(place.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              Text(place.formattedAddress ?? 'Dirección no disponible'),
            ],
          ),
          onTap: () {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(place.latLng, 16.0),
            );
          },
        );
      },
    );
  }
}