import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'model_state.dart';
import 'package:flutter/material.dart';

class ModelStateStore {
  final _stateController = BehaviorSubject<ModelState>();
  final _exportClicks = PublishSubject<bool>();
  final _saveClicks = PublishSubject<bool>();
  final _selectedLayerController = BehaviorSubject<String?>(); // Track selected layer

  Stream<ModelState> get state => _stateController.stream;
  Stream<bool> get exportClicks => _exportClicks.stream;
  Stream<bool> get saveClicks => _saveClicks.stream;
  Stream<String?> get selectedLayer => _selectedLayerController.stream;

  ModelStateStore() {
    print('ModelStateStore: Instance created');

    // ✅ When initialized, create a default layer (so users see something)
    final defaultState = ModelState(layers: [
      Layer(
        id: "layer_1",
        type: LayerType.text, // Default to a text layer
        order: 1,
        content: "Layer 1", // Placeholder text
        x: 100,
        y: 100,
        rotation: 0,
        scale: 1.0,
        fontSize: 24,
        color: Colors.black,
      )
    ], backgroundColor: Colors.white);

    _stateController.sink.add(defaultState);
    _selectedLayerController.sink.add("layer_1"); // Auto-select the first layer
  }

  void updateState(ModelState Function(ModelState) producer) {
    final currentState = _stateController.valueOrNull ?? ModelState(layers: []);
    final newState = producer(currentState);
    try {
      _stateController.sink.add(newState);
      print('ModelStateStore: State updated to $newState');
    } catch (e) {
      print('ModelStateStore: Error updating state: $e');
    }
  }

  void selectLayer(String layerId) {
    _selectedLayerController.sink.add(layerId);
  }

  void addLayer(Layer newLayer) {
    updateState((state) {
      final updatedLayers = List<Layer>.from(state.layers)..add(newLayer);
      return state.copyWith(layers: updatedLayers);
    });
  }

  void removeLayer(String layerId) {
    updateState((state) {
      final updatedLayers = state.layers.where((l) => l.id != layerId).toList();
      return state.copyWith(layers: updatedLayers);
    });

    // If the removed layer was selected, clear selection
    if (_selectedLayerController.valueOrNull == layerId) {
      _selectedLayerController.sink.add(null);
    }
  }

  void updateLayer(Layer updatedLayer) {
    updateState((state) {
      final updatedLayers = state.layers.map((l) {
        return l.id == updatedLayer.id ? updatedLayer : l;
      }).toList();
      return state.copyWith(layers: updatedLayers);
    });
  }

  void dispose() {
    _stateController.close();
    _exportClicks.close();
    _saveClicks.close();
    _selectedLayerController.close();
    print('ModelStateStore: Instance disposed');
  }

  void export() {
    _exportClicks.sink.add(true);
  }

  void save() {
    _saveClicks.sink.add(true);
  }
}
