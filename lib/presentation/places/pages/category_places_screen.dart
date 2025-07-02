// lib/presentation/places/pages/category_places_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/data/places/datasources/google_places_data_source.dart';
import 'package:vive_huanchaco/data/places/models/place_api_models.dart' as api;

class CategoryPlacesScreen extends StatefulWidget {
  final String category;
  const CategoryPlacesScreen({required this.category, super.key});

  @override
  State<CategoryPlacesScreen> createState() => _CategoryPlacesScreenState();
}

class _CategoryPlacesScreenState extends State<CategoryPlacesScreen> {
  final api.Location _huanchacoLocation = api.Location(latitude: -8.0777, longitude: -79.1205);
  final ScrollController _scrollController = ScrollController();

  final GooglePlacesDataSource _placesDataSource = GooglePlacesDataSource();
  final Set<String> _loadedPlaceIds = {};

  List<api.Place> _places = [];
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  bool _isLoading = true;
  bool _isLoadingMore = false;
  double _radius = 1000.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      if (_radius < 6000.0) {
        _radius += 1000.0;
        _loadPlaces(append: true);
      }
    }
  }

  String _getGoogleType(String category) {
    switch (category.toLowerCase()) {
      case 'museos': return 'museum';
      case 'hoteles': return 'lodging';
      case 'restaurantes': return 'restaurant';
      case 'cafeterías': return 'cafe';
      case 'parques': return 'park';
      case 'bares': return 'bar';
      default: return 'tourist_attraction';
    }
  }

  Future<void> _loadPlaces({bool append = false}) async {
    setState(() {
      if (!append) _isLoading = true;
      _isLoadingMore = append;
    });

    try {
      final type = _getGoogleType(widget.category);
      final newPlaces = await _placesDataSource.searchNearby(type, _huanchacoLocation, radius: _radius);
      final uniquePlaces = newPlaces.where((p) => !_loadedPlaceIds.contains(p.name)).toList();
      _loadedPlaceIds.addAll(uniquePlaces.map((e) => e.name));

      setState(() {
        _places.addAll(uniquePlaces);
        _markers.addAll(uniquePlaces.map((p) => Marker(
          markerId: MarkerId(p.name),
          position: p.latLng,
          infoWindow: InfoWindow(title: p.displayName.text),
        )));
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_huanchacoLocation.latitude, _huanchacoLocation.longitude),
            zoom: 14,
          ),
          onMapCreated: (controller) => _mapController = controller,
          markers: _markers,
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)));
    }
    if (_places.isEmpty) return const Center(child: Text('No se encontraron lugares.'));

    return ListView.builder(
      controller: _scrollController,
      itemCount: _places.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (_, index) {
        if (index >= _places.length) return const Padding(
          padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
        
        final place = _places[index];
        final photo = place.photos?.isNotEmpty == true ? place.photos!.first.name : null;
        final photoUrl = photo != null ? _placesDataSource.getPhotoUrl(photo) : null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(photoUrl, width: 60, height: 60, fit: BoxFit.cover),
                  )
                : const Icon(Icons.image, size: 48, color: Colors.grey),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(place.displayName.text, overflow: TextOverflow.ellipsis)),
                if (place.rating != null)
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(place.rating!.toStringAsFixed(1)),
                    ],
                  ),
              ],
            ),
            subtitle: Text(place.formattedAddress ?? 'Dirección no disponible'),
            onTap: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(place.latLng, 16),
              );
            },
          ),
        );
      },
    );
  }
}
