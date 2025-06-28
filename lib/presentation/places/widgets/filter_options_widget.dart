import 'package:flutter/material.dart';

class FilterOptionsWidget extends StatefulWidget {
  const FilterOptionsWidget({super.key});

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  bool _isOpenNow = false;
  int? _ratingGroupValue;
  int? _sortByGroupValue = 1; // "Más relevantes" por defecto
  double _distanceValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Filtros", style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            
            // FILTRO: ESTADO
            SwitchListTile(
              title: const Text("Abierto Ahora"),
              value: _isOpenNow,
              onChanged: (bool value) {
                setState(() => _isOpenNow = value);
              },
            ),
            const Divider(),

            // FILTRO: CALIFICACIÓN
            const Text("Calificación Mínima", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildRatingFilter(),
            const Divider(),

            // FILTRO: ORDENAR POR
            const Text("Ordenar por", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSortByFilter(),
            const Divider(),

            // FILTRO: DISTANCIA
            const Text("Distancia Máxima", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDistanceFilter(),
            const SizedBox(height: 20),

            // BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Lógica para limpiar filtros
                    setState(() {
                      _isOpenNow = false;
                      _ratingGroupValue = null;
                      _sortByGroupValue = 1;
                      _distanceValue = 5.0;
                    });
                  },
                  child: const Text("Limpiar Filtros"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para aplicar filtros
                    Navigator.pop(context);
                  },
                  child: const Text("Aplicar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ChoiceChip(label: const Text("4+ ★"), selected: _ratingGroupValue == 4, onSelected: (v) => setState(() => _ratingGroupValue = 4)),
        ChoiceChip(label: const Text("3+ ★"), selected: _ratingGroupValue == 3, onSelected: (v) => setState(() => _ratingGroupValue = 3)),
        ChoiceChip(label: const Text("2+ ★"), selected: _ratingGroupValue == 2, onSelected: (v) => setState(() => _ratingGroupValue = 2)),
      ],
    );
  }

  Widget _buildSortByFilter() {
    return Column(
      children: [
        RadioListTile<int>(
          title: const Text("Más relevantes"),
          value: 1,
          groupValue: _sortByGroupValue,
          onChanged: (v) => setState(() => _sortByGroupValue = v),
        ),
        RadioListTile<int>(
          title: const Text("Más cercanos"),
          value: 2,
          groupValue: _sortByGroupValue,
          onChanged: (v) => setState(() => _sortByGroupValue = v),
        ),
         RadioListTile<int>(
          title: const Text("Mejor valorados"),
          value: 3,
          groupValue: _sortByGroupValue,
          onChanged: (v) => setState(() => _sortByGroupValue = v),
        ),
      ],
    );
  }
   Widget _buildDistanceFilter() {
    return Column(
      children: [
        Slider(
          value: _distanceValue,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: "${_distanceValue.toStringAsFixed(0)} km",
          onChanged: (double value) {
            setState(() => _distanceValue = value);
          },
        ),
        Text("Hasta ${_distanceValue.toStringAsFixed(0)} km de distancia")
      ],
    );
  }
}