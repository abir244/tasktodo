
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/map_service.dart';
import '../viewmodel/location_viewmodel.dart';
import 'map_fullscreen_screen.dart';

class ChooseLocationScreen extends ConsumerStatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  ConsumerState<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends ConsumerState<ChooseLocationScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationViewModelProvider);
    final vm = ref.read(locationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0C11),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const Text("Skip", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 35),
              const Text(
                "Choose Location",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your location will be used to find the best recommendation events near you.",
                style: TextStyle(color: Colors.white60, height: 1.4),
              ),
              const SizedBox(height: 25),

              // Search bar (UI only for now)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.25),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white70),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Map preview (rounded like Figma)
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Builder(
                    builder: (context) {
                      if (state.isLoading || state.current == null) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        );
                      }
                      final selected = state.selected ?? state.current!;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(target: selected, zoom: 15),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            onMapCreated: (c) {
                              _controller = c;
                            },
                            onCameraMove: (p) => vm.onCameraMove(p.target),
                            onCameraIdle: () => vm.onCameraIdle(),
                          ),

                          // Center pin (Figma style)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                            child: const Icon(Icons.location_on, size: 28, color: Colors.black),
                          ),

                          // Address pill
                          if (state.address != null && state.address!.isNotEmpty)
                            Positioned(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xAA1A1A22),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Text(
                                  state.address!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Use Current Location
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDDF99),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    vm.centerOnCurrent();
                    final sel = ref.read(locationViewModelProvider).selected;
                    if (sel != null && _controller != null) {
                      _controller!.animateCamera(MapService.cameraTo(sel, zoom: 15));
                    }
                  },
                  child: const Text("Use Current Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),

              // Set Location on Map
              SizedBox(
                height: 55,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEDDF99), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final st = ref.read(locationViewModelProvider);
                    // TODO: Save selected coordinates to backend/state as needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapFullscreenScreen()),
                    );
                  },
                  child: const Text(
                    "Set Location On Map",
                    style: TextStyle(color: Color(0xFFEDDF99), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

