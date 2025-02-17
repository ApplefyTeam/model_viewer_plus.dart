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
    try {
      print("🔄 [MobileModelEditor] Updating state...");

      // 1. **Set Background Color**
      final bgHex = state.backgroundColor?.toHex() ?? "#ffffff";
      print("🎨 [MobileModelEditor] Setting background color: $bgHex");

      // ✅ Use `runJavaScript()` because `setBackgroundColorJS` does not return a value
      await _controller.runJavaScript('setBackgroundColorJS("$bgHex");');
      print("✅ [MobileModelEditor] Background color applied.");

      // 2. **Clear Existing Layers**
      print("🗑️ [MobileModelEditor] Clearing existing layers...");
      await _controller.runJavaScript('layers = [];');
      print("✅ [MobileModelEditor] Layer clearing complete.");

      // 3. **Re-add Layers**
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

        print("🆕 [MobileModelEditor] Adding layer: ${layer.id}");
        print("📌 Type: $typeString");
        print("📌 Content: $contentString");
        print("📌 Order: $orderValue");
        print("📌 X: $xValue, Y: $yValue");
        print("📌 Rotation: $rotationValue, Scale: $scaleValue");
        print("📌 Font Size: $fontSizeValue, Color: $colorHex");
        print("📌 Image Width: $imageWidthValue, Image Height: $imageHeightValue");

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

        // ✅ Use `runJavaScript()` since `addLayer()` does not return a value
        await _controller.runJavaScript(jsAddLayer);
        print("✅ [MobileModelEditor] Layer added.");
      }

      print("🎉 [MobileModelEditor] State update complete!");
    } catch (e) {
      print("🚨 [MobileModelEditor] JavaScript execution error: $e");
    }
  }

  /// Calls the JS function to export the .glb
  void export() async {
    try {
      print("🚀 [MobileModelEditor] Exporting GLB...");
      final result = await _controller.runJavaScriptReturningResult("exportGLB();");
      print("✅ [MobileModelEditor] Export result: $result");
    } catch (e) {
      print("🚨 [MobileModelEditor] Export error: $e");
    }
  }

  /// Calls the JS function to save the .glb
  void save() async {
    try {
      print("💾 [MobileModelEditor] Saving GLB...");
      final result = await _controller.runJavaScriptReturningResult("saveGLB();");
      print("✅ [MobileModelEditor] Save result: $result");
    } catch (e) {
      print("🚨 [MobileModelEditor] Save error: $e");
    }
  }
}
