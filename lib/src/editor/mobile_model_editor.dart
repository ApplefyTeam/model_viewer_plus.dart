import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../util/hex_color.dart';
import 'model_state.dart';

class MobileModelEditor {
  MobileModelEditor(this._controller);

  final WebViewController _controller;

  /// Updates the background color and sends the layer state to JS.
  void updateState(ModelState state) async {
    try {
      print("🔄 [MobileModelEditor] Updating state...");

      // 1. **Set Background Color**
      final bgHex = state.backgroundColor?.toHex() ?? "#ffffff";
      print("🎨 [MobileModelEditor] Setting background color: $bgHex");

      await _controller.runJavaScript('setBackgroundColorJS("$bgHex");');
      print("✅ [MobileModelEditor] Background color applied.");

      // 2. **Convert Dart layers to JSON for JS rendering**
      final String layersJson = _convertLayersToJson(state.layers);
      print("🆕 [MobileModelEditor] Sending layers: $layersJson");

      await _controller.runJavaScript('renderLayersJS($layersJson);');
      print("✅ [MobileModelEditor] Layers rendered.");

      print("🎉 [MobileModelEditor] State update complete!");
    } catch (e) {
      print("🚨 [MobileModelEditor] JavaScript execution error: $e");
    }
  }

  /// Calls the JS function to export the .glb
  void export() async {
    try {
      print("🚀 [MobileModelEditor] Exporting GLB...");
      await _controller.runJavaScript("exportGLB();");
      print("✅ [MobileModelEditor] Export complete.");
    } catch (e) {
      print("🚨 [MobileModelEditor] Export error: $e");
    }
  }

  /// Calls the JS function to save the .glb
  void save() async {
    try {
      print("💾 [MobileModelEditor] Saving GLB...");
      await _controller.runJavaScript("saveGLB();");
      print("✅ [MobileModelEditor] Save complete.");
    } catch (e) {
      print("🚨 [MobileModelEditor] Save error: $e");
    }
  }

  /// **Test method to add layers & background color**
  void addTestLayers() async {
    try {
      print("🔹 [MobileModelEditor] Adding test layers...");

      // **Set a test background color**
      final testColor = "#add8e6"; // Light blue
      await _controller.runJavaScript('setBackgroundColorJS("$testColor");');
      print("✅ [MobileModelEditor] Background color set to $testColor.");

      // **Create a test layer**
      final List<Map<String, dynamic>> testLayers = [
        {
          "id": "test_layer",
          "type": "text",
          "content": "Test Layer",
          "order": 0,
          "x": 100,
          "y": 100,
          "rotation": 0,
          "scale": 1.0,
          "fontSize": 20,
          "color": "#ff0000", // Red text
          "imageWidth": 100,
          "imageHeight": 100,
          "visible": true,
          "selected": true,
        }
      ];

      final String layersJson = jsonEncode(testLayers);
      print("📌 [MobileModelEditor] Sending test layers: $layersJson");

      await _controller.runJavaScript('renderLayersJS($layersJson);');
      print("✅ [MobileModelEditor] Triggered re-render of layers.");

    } catch (e) {
      print("🚨 [MobileModelEditor] Test layer error: $e");
    }
  }

  /// Converts Dart layer list to JSON for JavaScript
  String _convertLayersToJson(List<Layer> layers) {
    final List<Map<String, dynamic>> mappedLayers = layers.map((layer) => {
      "id": layer.id,
      "type": layer.type == LayerType.text ? "text" : "image",
      "content": layer.content ?? "",
      "order": layer.order,
      "x": layer.x ?? 0,
      "y": layer.y ?? 0,
      "rotation": layer.rotation ?? 0,
      "scale": layer.scale ?? 1.0,
      "fontSize": layer.fontSize ?? 24,
      "color": layer.color?.toHex() ?? "#000000",
      "imageWidth": layer.imageWidth ?? 100,
      "imageHeight": layer.imageHeight ?? 100,
      "visible": layer.visible,
      "selected": layer.selected,
    }).toList();

    return jsonEncode(mappedLayers);
  }
}
