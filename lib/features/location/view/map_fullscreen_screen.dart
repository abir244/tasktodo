
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../viewmodel/location_viewmodel.dart';

class MapFullscreenScreen extends ConsumerStatefulWidget {
  const MapFullscreenScreen({super.key});

  @override
  ConsumerState<MapFullscreenScreen> createState() => _MapFullscreenScreenState();
}

class _MapFullscreenScreenState extends ConsumerState<MapFullscreenScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationViewModelProvider);
    final vm = ref.read(locationViewModelProvider.notifier);

    final selected = state.selected ?? state.current;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0C11),
      body: SafeArea(
        child: Stack(
          children: [
            if (selected == null)
              const Center(child: CircularProgressIndicator(color: Colors.amber))
            else
              GoogleMap(
                initialCameraPosition: CameraPosition(target: selected, zoom: 16),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (c) => _controller = c,
                onCameraMove: (p) => vm.onCameraMove(p.target),
                onCameraIdle: () => vm.onCameraIdle(),
              ),

            // Center pin
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.location_pin, color: Colors.amber, size: 36),
            ),

            // Address bar
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xAA1A1A22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  state.address ?? 'Move the map to select a location…',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),

            // Confirm button
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDDF99),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final s = ref.read(locationViewModelProvider);
                    final sel = s.selected;
                    if (sel != null) {
                      // TODO: Persist selection to state/back-end
                      Navigator.pop(context); // Return to previous screen
                    }
                  },
                  child: const Text("Confirm Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

