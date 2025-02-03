@JS()
library;

import 'dart:js_interop';
import 'dart:ui';

import '../../model_viewer_plus.dart';
import '../util/hex_color.dart';

@JS()
external void addLayerToJS(
    String id,
    String type,
    String content,
    int order,
    int x,
    int y,
    int rotation,
    double scale,
    int fontSize,
    String color,
    double? imageWidth,
    double? imageHeight);

@JS()
external void removeLayerFromJS(String id);

@JS()
external void updateLayerInJS(
    String id,
    int? x,
    int? y,
    int? rotation,
    double? scale,
    int? fontSize,
    String? color,
    double? imageWidth,
    double? imageHeight);

@JS()
external void setBackgroundColor(String color);

@JS()
external void toggleControlsVisibility();

@JS()
external void exportGLB();

@JS()
external void saveGLB();

class WebModelEditor {
  void updateState(ModelState state) {
    // Ensure background color is set
    setBackgroundColor(state.backgroundColor?.toHex() ?? "#ffffff");

    // If no layers exist, add a default text layer
    if (state.layers.isEmpty) {
      print("No layers found. Adding default text layer.");
      final defaultLayer = Layer(
        id: "layer_1",
        type: LayerType.text,
        content: "Hello",
        order: 0,
        x: 50,
        y: 50,
        rotation: 0,
        scale: 1.0,
        fontSize: 32,
        color: Color.fromRGBO(0, 0, 0, 1.0),
      );

      addLayer(defaultLayer);
    }

    // Clear existing layers from JS before re-adding them
    for (final layer in state.layers) {
      print("Adding Layer to JS: ${layer.id} | ${layer.content}");

      addLayerToJS(
        layer.id,
        layer.type == LayerType.text ? "text" : "image",
        layer.content ?? "",
        layer.order,
        layer.x ?? 0,
        layer.y ?? 0,
        layer.rotation ?? 0,
        layer.scale ?? 1.0,
        layer.fontSize ?? 24,
        layer.color?.toHex() ?? "#000000",
        layer.imageWidth,
        layer.imageHeight,
      );
    }
  }

  void setCanvasBackgroundColor(String? hexColor) {
    setBackgroundColor(hexColor ?? "#ffffff");
  }

  void addLayer(Layer layer) {
    print("Adding Layer: ${layer.id} | Type: ${layer.type}");
    addLayerToJS(
      layer.id,
      layer.type == LayerType.text ? "text" : "image",
      layer.content ?? "",
      layer.order,
      layer.x ?? 0,
      layer.y ?? 0,
      layer.rotation ?? 0,
      layer.scale ?? 1.0,
      layer.fontSize ?? 24,
      layer.color?.toHex() ?? "#000000",
      layer.imageWidth,
      layer.imageHeight,
    );
  }

  void removeLayer(String id) {
    print("Removing Layer: $id");
    removeLayerFromJS(id);
  }

  void updateLayer(Layer layer) {
    print("Updating Layer: ${layer.id}");
    updateLayerInJS(
      layer.id,
      layer.x,
      layer.y,
      layer.rotation,
      layer.scale,
      layer.fontSize,
      layer.color?.toHex(),
      layer.imageWidth,
      layer.imageHeight,
    );
  }

  void export() {
    print("Exporting GLB...");
    exportGLB();
  }

  void save() {
    print("Saving GLB...");
    saveGLB();
  }
}
