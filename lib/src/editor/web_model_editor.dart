@JS()
library;

import 'dart:ui';
import 'dart:js_interop';
import 'dart:js_util' as js_util;

import '../../model_viewer_plus.dart';
import '../util/hex_color.dart';

@JS()
external void renderLayersJS(JSArray layers); // ✅ Uses JSArray directly

@JS()
external void setBackgroundColorJS(String color);

@JS()
external void exportGLB();
@JS()
external void saveGLB();

class WebModelEditor {
  void updateState(ModelState state) {
    return;
  }

  void addLayer(Layer layer) {
    print("Adding Layer: ${layer.id} | Type: ${layer.type}");
  }

  void updateLayer(Layer layer) {
    print("Updating Layer: ${layer.id}");
  }

  void removeLayer(String id) {
    print("Removing Layer: $id");
  }

  void setCanvasBackgroundColor(String? hexColor) {
    if (hexColor == null) return;
    setBackgroundColorJS(hexColor);
  }

  void export() => addTestLayers();
  void save() => saveGLB();

  void setTestBackgroundColor() {
    print("🎨 Changing background color to test value...");

    final testColor = "#add8e6"; // Light blue for visibility

    print("🚀 Sending background color to JS: $testColor");

    setBackgroundColorJS(testColor);

    print("✅ Background color set successfully.");
  }

  // Convert Dart list to JSArray before passing
  void addTestLayers() {
    print("🔹 Exporting test layers...");

    setTestBackgroundColor();

    final List<Layer> testLayers = [
      Layer(
        id: "test_layer",
        type: LayerType.text,
        content: "Test Text",
        order: 0,
        x: 0,
        y: 0,
        rotation: 10,
        scale: 1.2,
        fontSize: 32,
        color: const Color(0xFF0000FF), // Blue
        visible: true,
      ),
      Layer(
        id: "test_image_layer",
        type: LayerType.image,
        content: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=", // Replace with an actual image URL
        order: 1,
        x: 50,
        y: 50,
        rotation: 0,
        scale: 1.0,
        fontSize: 0,
        color: null, // Not needed for images
        imageWidth: 150,
        imageHeight: 150,
        visible: true,
      ),
    ];

    // Convert List<Layer> to a JS-compatible JSArray
    final JSArray jsLayers = convertLayersToJSArray(testLayers);

    print("🚀 Sending test layers to JS...");
    renderLayersJS(jsLayers); // ✅ Works now

    print("✅ Test layers sent successfully.");
  }

  JSArray convertLayersToJSArray(List<Layer> layers) {
    final List<Map<String, dynamic>> mappedLayers =
    layers.map((layer) => convertLayerToMap(layer)).toList();

    // ✅ Convert Dart List into JavaScript-compatible array
    return js_util.jsify(mappedLayers) as JSArray;
  }

  Map<String, dynamic> convertLayerToMap(Layer layer) {
    return {
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
      "imageWidth": layer.imageWidth,
      "imageHeight": layer.imageHeight,
      "visible": layer.visible,
    };
  }
}