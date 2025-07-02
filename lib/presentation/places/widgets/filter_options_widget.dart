// 📁 lib/presentation/places/widgets/filter_options_widget.dart

import 'package:flutter/material.dart';

class PlaceFilterOptions {
  double minRating;
  double maxDistance;
  String orderBy; // 'name' o 'rating'
  bool descending;
  bool onlyOpenNow;

  PlaceFilterOptions({
    this.minRating = 0.0,
    this.maxDistance = 7000.0,
    this.orderBy = 'rating',
    this.descending = true,
    this.onlyOpenNow = false,
  });
}

class FilterOptionsWidget extends StatefulWidget {
  final PlaceFilterOptions initialOptions;
  final void Function(PlaceFilterOptions) onApply;

  const FilterOptionsWidget({
    super.key,
    required this.initialOptions,
    required this.onApply,
  });

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late PlaceFilterOptions options;

  @override
  void initState() {
    super.initState();
    options = PlaceFilterOptions(
      minRating: widget.initialOptions.minRating,
      maxDistance: widget.initialOptions.maxDistance,
      orderBy: widget.initialOptions.orderBy,
      descending: widget.initialOptions.descending,
      onlyOpenNow: widget.initialOptions.onlyOpenNow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtrar por calificación mínima', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: options.minRating,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label: options.minRating.toStringAsFixed(1),
            onChanged: (value) => setState(() => options.minRating = value),
          ),
          const SizedBox(height: 10),
          const Text('Distancia máxima (en metros)', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: options.maxDistance,
            min: 1000.0,
            max: 7000.0,
            divisions: 6,
            label: '${options.maxDistance.round()} m',
            onChanged: (value) => setState(() => options.maxDistance = value),
          ),
          const SizedBox(height: 10),
          const Text('Ordenar por', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              DropdownButton<String>(
                value: options.orderBy,
                items: const [
                  DropdownMenuItem(value: 'rating', child: Text('Calificación')),
                  DropdownMenuItem(value: 'name', child: Text('Nombre')),
                ],
                onChanged: (value) => setState(() => options.orderBy = value!),
              ),
              const SizedBox(width: 10),
              Switch(
                value: options.descending,
                onChanged: (value) => setState(() => options.descending = value),
              ),
              Text(options.descending ? 'Descendente' : 'Ascendente'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Switch(
                    value: options.onlyOpenNow,
                    onChanged: (value) => setState(() => options.onlyOpenNow = value),
                  ),
                  const Text('Solo abiertos ahora')
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onApply(options);
                },
                child: const Text('Aplicar'),
              )
            ],
          )
        ],
      ),
    );
  }
}