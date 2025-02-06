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
    int visible
    );

@JS()
external void setBackgroundColorJS(String color);

@JS()
external void exportGLB();
@JS()
external void saveGLB();

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
        visible: true
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
        layer.visible ? 1 : 0
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
      layer.visible ? 1 : 0
    );
  }

  void updateLayer(Layer layer) {
    print("Updating Layer: ${layer.id}");
  }

  void removeLayer(String id) {
    print("Removing Layer: $id");
  }

  // Possibly omit or fix if you want background color
  void setCanvasBackgroundColor(String? hexColor) {
    if (hexColor == null) return;
    setBackgroundColorJS(hexColor);
  }

  void export() => addTestBoth();
  void save() => saveGLB();

  void addTestBoth() {
    addTestImageLayer();
    addTestTextLayer();
    setTestBackgroundColor();
  }

  void addTestTextLayer() {
    print("🔹 Export button clicked. Instead of exporting, adding test layer.");

    final testLayer = Layer(
      id: "test_layer",
      type: LayerType.text,
      content: "Test",
      order: 0,
      x: 0,
      y: 0,
      rotation: 0,
      scale: 1.0,
      fontSize: 16,
      color: const Color(0xFF0000FF), // Blue color for visibility
      visible: true
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
      testLayer.visible ? 1 : 0
    );

    print("✅ Test layer added successfully.");
  }

  void addTestImageLayer() {
    print("🔹 Export button clicked. Instead of exporting, adding test image layer.");

    final testImageLayer = Layer(
      id: "test_image_layer",
      type: LayerType.image,
      content: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=", // Replace with an actual image URL
      order: 1,
      x: 50,
      y: 50,
      rotation: 0,
      scale: 1.0,
      fontSize: 0, // Not needed for images
      color: null, // Not needed for images
      imageWidth: 150, // Image width
      imageHeight: 150, // Image height
      visible: false
    );

    print("🚀 Adding test image layer to JS...");

    addLayerToJS(
      testImageLayer.id,
      "image",
      testImageLayer.content ?? "",
      testImageLayer.order,
      testImageLayer.x ?? 0,
      testImageLayer.y ?? 0,
      testImageLayer.rotation ?? 0,
      testImageLayer.scale ?? 1.0,
      testImageLayer.fontSize ?? 0, // Not needed for images
      "#000000", // Default color (not used for images)
      testImageLayer.imageWidth,
      testImageLayer.imageHeight,
      testImageLayer.visible ? 1 : 0
    );

    print("✅ Test image layer added successfully.");
  }

  void setTestBackgroundColor() {
    print("🎨 Changing background color to test value...");

    final testColor = "#add8e6"; // Light blue for visibility

    print("🚀 Sending background color to JS: $testColor");

    setBackgroundColorJS(testColor);

    print("✅ Background color set successfully.");
  }
}