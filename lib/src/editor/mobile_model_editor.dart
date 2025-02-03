import 'package:webview_flutter/webview_flutter.dart';

import '../util/hex_color.dart';
import 'model_state.dart';

class MobileModelEditor {
  MobileModelEditor(this._controller);

  final WebViewController _controller;

  /// Replaces the old single-layer logic with multi-layer commands:
  /// 1. Sets the background color.
  /// 2. Clears existing JS layers.
  /// 3. Re-adds each layer from [ModelState].
  void updateState(ModelState state) async {
    // 1. Set background color (or default to white).
    final bgHex = state.backgroundColor?.toHex() ?? "#ffffff";
    await _controller.runJavaScript(
      'setBackgroundColor("$bgHex");',
    );

    // 2. Clear existing JS layers by resetting the global `layers` array.
    //    (If you have a dedicated `clearLayers()` JS function, call that instead.)
    await _controller.runJavaScript('layers = [];');

    // 3. Re-add each layer by calling `addLayer(...)` in JS.
    for (final layer in state.layers) {
      final typeString = layer.type == LayerType.text ? "text" : "image";
      final contentString = layer.content ?? "";
      final orderValue = layer.order ?? 0;
      final xValue = layer.x ?? 0;
      final yValue = layer.y ?? 0;
      final rotationValue = layer.rotation ?? 0;
      final scaleValue = layer.scale ?? 1.0;
      final fontSizeValue = layer.fontSize ?? 24;
      final colorHex = layer.color?.toHex() ?? "#000000";
      final imageWidthValue = layer.imageWidth ?? 100;
      final imageHeightValue = layer.imageHeight ?? 100;

      final jsAddLayer = """
        addLayer("$typeString", "$contentString", {
          order: $orderValue,
          x: $xValue,
          y: $yValue,
          rotation: $rotationValue,
          scale: $scaleValue,
          fontSize: $fontSizeValue,
          color: "$colorHex",
          imageWidth: $imageWidthValue,
          imageHeight: $imageHeightValue
        });
      """;

      // Run the JavaScript to add this layer
      await _controller.runJavaScript(jsAddLayer);
    }
  }

  /// Calls the JS function to export the .glb
  void export() {
    _controller.runJavaScript("exportGLB()");
  }

  /// Calls the JS function to save the .glb
  void save() {
    _controller.runJavaScript("saveGLB()");
  }
}
