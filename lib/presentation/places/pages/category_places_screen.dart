// lib/presentation/places/pages/category_places_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/data/places/datasources/google_places_data_source.dart';
import 'package:vive_huanchaco/data/places/models/place_api_models.dart' as api;
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

  final api.Location _huanchacoLocation =
      api.Location(latitude: -8.0777, longitude: -79.1205);

  @override
  void initState() {
    super.initState();
    _placesDataSource = GooglePlacesDataSource();
    _fetchPlaces();
  }

  String _getGooglePlaceType(String category) {
    switch (category.toLowerCase()) {
      case 'museos':
        return 'museum';
      case 'hoteles':
        return 'lodging';
      case 'restaurantes':
        return 'restaurant';
      case 'cafeterías':
        return 'cafe';
      case 'parques':
        return 'park';
      case 'bares':
        return 'bar';
      case 'bancos':
        return 'bank';
      default:
        return 'tourist_attraction';
    }
  }

  Future<void> _fetchPlaces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final type = _getGooglePlaceType(widget.category);
      final results = await _placesDataSource.searchNearby(type, _huanchacoLocation);

      _updateMarkers(results);
      setState(() {
        _places = results;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMarkers(List<api.Place> places) {
    final newMarkers = places.map((place) {
      return Marker(
        markerId: MarkerId(place.name),
        position: place.latLng,
        infoWindow: InfoWindow(title: place.displayName.text),
      );
    }).toSet();
    setState(() => _markers.addAll(newMarkers));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  _huanchacoLocation.latitude, _huanchacoLocation.longitude),
              zoom: 14),
          onMapCreated: (controller) => _mapController = controller,
          markers: _markers,
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
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
          child: Text(_errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      );
    }
    if (_places.isEmpty) {
      return const Center(child: Text('No se encontraron lugares.'));
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
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

  Widget _buildPlacesList(
      List<api.Place> places, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final photoName = place.photos?.isNotEmpty == true
            ? place.photos!.first.name
            : null;
        final photoUrl =
            photoName != null ? _placesDataSource.getPhotoUrl(photoName) : null;

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: photoUrl != null
                      ? Image.network(
                          photoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 48, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y calificación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              place.displayName.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (place.rating != null)
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${place.rating}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.formattedAddress ?? 'Dirección no disponible',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
