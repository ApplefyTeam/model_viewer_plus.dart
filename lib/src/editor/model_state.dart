import 'package:flutter/material.dart';

enum LayerType { text, image }

class Layer {
  Layer({required this.id,
    required this.type,
    required this.content,
    required this.order,
    this.x,
    this.y,
    this.rotation,
    this.scale,
    this.fontSize,
    this.color,
    this.imageWidth,
    this.imageHeight,
    this.visible = true,
    this.selected = false,
  });

  final String id; // Unique id for the layer
  final LayerType? type; // `text` or `image`
  final String? content; // Text content or image path
  final int order;
  final int? x;
  final int? y;
  final int? rotation;
  final double? scale; // Added for resizing
  final int? fontSize;
  final Color? color;
  final double? imageWidth; // added to store original width
  final double? imageHeight; // added to store original height
  bool visible; // for layer visibility
  bool selected;

  Layer copyWith({String? id,
    LayerType? type,
    String? content,
    int? order,
    int? x,
    int? y,
    int? rotation,
    double? scale,
    int? fontSize,
    Color? color,
    double? imageWidth,
    double? imageHeight,
    bool? visible,
    bool? selected}) =>
      Layer(
          id: id ?? this.id,
          type: type ?? this.type,
          content: content ?? this.content,
          order: order ?? this.order,
          x: x ?? this.x,
          y: y ?? this.y,
          rotation: rotation ?? this.rotation,
          scale: scale ?? this.scale,
          fontSize: fontSize ?? this.fontSize,
          color: color ?? this.color,
          imageWidth: imageWidth ?? this.imageWidth,
          imageHeight: imageHeight ?? this.imageHeight,
          visible: visible ?? this.visible,
          selected: selected ?? this.selected
      );
}

class ModelState {
  ModelState({
    List<Layer>? layers,
    this.backgroundColor,
  }) : layers = layers ?? [];

  final List<Layer> layers;
  final Color? backgroundColor;

  ModelState copyWith({List<Layer>? layers, Color? bgColor}) =>
      ModelState(
        layers: layers ?? this.layers,
        backgroundColor: bgColor ?? this.backgroundColor,
      );
}