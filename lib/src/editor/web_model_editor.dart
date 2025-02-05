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
    double? imageHeight,
    );

// @JS()
// external void removeLayerFromJS(String id);

/// IMPORTANT: Notice we accept type, content, etc. in the correct order now:
// @JS()
// external void updateLayerInJS(
//     String id,
//     String type,
//     String content,
//     int order,
//     int x,
//     int y,
//     int rotation,
//     double scale,
//     int fontSize,
//     String color,
//     double? imageWidth,
//     double? imageHeight,
//     );

// @JS()
// external void setBackgroundColorJS(String color);

// @JS()
// external void toggleControlsVisibility();
@JS()
external void exportGLB();
@JS()
external void saveGLB();
// @JS()
// external void clearAllLayersJS();

class WebModelEditor {

  void updateState(ModelState state) {
    return;
    print('hop: web_model_editor.dart: updateState(), state: $state');

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
        color: const Color(0xFF000000),
      );
      addLayer(defaultLayer);
    }

    // Send each layer to JS
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

  void updateLayer(Layer layer) {
    print("Updating Layer: ${layer.id}");
    // updateLayerInJS(
    //   layer.id,
    //   layer.type == LayerType.text ? "text" : "image",
    //   layer.content ?? "",
    //   layer.order,
    //   layer.x ?? 0,
    //   layer.y ?? 0,
    //   layer.rotation ?? 0,
    //   layer.scale ?? 1.0,
    //   layer.fontSize ?? 24,
    //   layer.color?.toHex() ?? "#000000",
    //   layer.imageWidth,
    //   layer.imageHeight,
    // );
  }

  void removeLayer(String id) {
    print("Removing Layer: $id");
    // removeLayerFromJS(id);
  }

  // Possibly omit or fix if you want background color
  void setCanvasBackgroundColor(String? hexColor) {
    if (hexColor == null) return;
    // setBackgroundColorJS(hexColor);
  }

  // void export() => exportGLB();
  void export() => addTestLayer();
  void save() => saveGLB();

  void addTestLayer() {
    print("🔹 Export button clicked. Instead of exporting, adding test layer.");

    final testLayer = Layer(
      id: "test_layer",
      type: LayerType.text,
      content: "Test Layer",
      order: 0,
      x: 0,
      y: 0,
      rotation: 0,
      scale: 1.0,
      fontSize: 32,
      color: const Color(0xFF0000FF), // Blue color for visibility
    );

    print("🚀 Adding test layer to JS...");

    addLayerToJS(
      testLayer.id,
      "text",
      testLayer.content ?? "",
      testLayer.order,
      testLayer.x ?? 0,
      testLayer.y ?? 0,
      testLayer.rotation ?? 0,
      testLayer.scale ?? 1.0,
      testLayer.fontSize ?? 24,
      testLayer.color?.toHex() ?? "#000000",
      testLayer.imageWidth,
      testLayer.imageHeight,
    );

    print("✅ Test layer added successfully.");
  }

}