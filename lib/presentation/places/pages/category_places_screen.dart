import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';
import 'package:vive_huanchaco/presentation/places/bloc/place_bloc.dart';
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
  final DraggableScrollableController _scrollController = DraggableScrollableController();
  double _mapFlex = 0.5; // Representa el 50% inicial del mapa

  @override
  void initState() {
    super.initState();
    context.read<PlaceBloc>().add(GetPlacesByCategoryEvent(category: widget.category));
    // Escuchar los cambios del DraggableScrollableSheet para ajustar el tamaño del mapa
    _scrollController.addListener(() {
      if (_scrollController.size > 0.5 && _scrollController.size <= 0.7) {
        setState(() {
          // El mapa se encoge hasta el 30% (1.0 - 0.7)
          _mapFlex = 1.0 - _scrollController.size; 
        });
      } else if (_scrollController.size > 0.9) {
        // Cuando la lista está casi al 100%, el mapa ocupa 0 espacio
        setState(() {
          _mapFlex = 0;
        });
      }
    });
  }

  void _updateMarkers(List<Place> places) {
    if (!mounted) return;
    setState(() {
      _markers.clear();
      for (final place in places) {
        _markers.add(Marker(
          markerId: MarkerId(place.id),
          position: place.location,
          infoWindow: InfoWindow(title: place.name, snippet: place.address),
        ));
      }
    });
    _moveCameraToBounds(places);
  }

  void _moveCameraToBounds(List<Place> places) {
    if (_mapController == null || places.isEmpty) return;
    final bounds = _createBounds(places);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
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
    return BlocListener<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state is PlacesLoaded) {
          _updateMarkers(state.places);
        } else if (state is PlaceError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      child: Stack(
        children: [
          // MAPA
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: MediaQuery.of(context).size.height * (1 - (_mapFlex)),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(target: LatLng(-8.086, -79.124), zoom: 13),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
            ),
          ),
          // LISTA DESLIZABLE
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.5, // La lista ocupa el 50%
            minChildSize: 0.5,     // Mínimo 50%
            maxChildSize: 1.0,     // Máximo 100%
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black26)],
                ),
                child: Column(
                  children: [
                    // Handle para indicar que es deslizable
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                    _buildSearchAndFilterBar(),
                    Expanded(
                      child: BlocBuilder<PlaceBloc, PlaceState>(
                        builder: (context, state) {
                          if (state is PlaceLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is PlacesLoaded) {
                            return _buildPlacesList(state.places, scrollController);
                          }
                          return const Center(child: Text('Selecciona una categoría para ver lugares.'));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
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

  Widget _buildPlacesList(List<Place> places, ScrollController scrollController) {
    if (places.isEmpty) {
      return const Center(child: Text('No se encontraron lugares.'));
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return ListTile(
          leading: SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                place.imageUrl ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.business),
              ),
            ),
          ),
          title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(place.address ?? 'Dirección no disponible'),
          onTap: () => print('Ir a ${place.name}'),
        );
      },
    );
  }
}