import 'package:flutter/material.dart';

// TODO: REMOVE
// enum TextureType {
//   none,
//   text,
//   ;
// }

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
    this.imageHeight});

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
    double? imageHeight}) =>
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
          imageHeight: imageHeight ?? this.imageHeight);
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

// class ModelState {
//   ModelState({
//     this.customText,
//     this.color,
//     this.backgroundColor,
//     this.fontSize,
//     this.textX,
//     this.textY,
//     this.textureType,
//     this.rotation,
//     this.imageSrc,
//     this.imageRotation,
//     this.imageX,
//     this.imageY,
//     this.imageScale, // Added for resizing
//     this.imageWidth, // Added to store original width
//     this.imageHeight, // Added to store original height
//   });
//
//   final String? customText;
//   final Color? color;
//   final Color? backgroundColor;
//   final int? fontSize;
//   final int? textX;
//   final int? textY;
//   final TextureType? textureType;
//   final int? rotation;
//   final String? imageSrc;
//   final int? imageRotation;
//   final int? imageX;
//   final int? imageY;
//   final double? imageScale; // Added for resizing
//   final double? imageWidth; // Added to store original width
//   final double? imageHeight; // Added to store original height
//
//
//   ModelState copyWith({
//     String? customText,
//     Color? color,
//     Color? backgroundColor,
//     int? fontSize,
//     TextureType? textureType,
//     int? textX,
//     int? textY,
//     int? rotation,
//     String? imageSrc,
//     int? imageRotation,
//     int? imageX,
//     int? imageY,
//     double? imageScale,
//     double? imageWidth,
//     double? imageHeight,
//   }) =>
//       ModelState(
//         customText: customText ?? this.customText,
//         color: color ?? this.color,
//         backgroundColor: backgroundColor ?? this.backgroundColor,
//         fontSize: fontSize ?? this.fontSize,
//         textureType: textureType ?? this.textureType,
//         textX: textX ?? this.textX,
//         textY: textY ?? this.textY,
//         rotation: rotation ?? this.rotation,
//         imageSrc: imageSrc ?? this.imageSrc,
//         imageRotation: imageRotation ?? this.imageRotation,
//         imageX: imageX ?? this.imageX,
//         imageY: imageY ?? this.imageY,
//         imageScale: imageScale ?? this.imageScale,
//         imageWidth: imageWidth ?? this.imageWidth,
//         imageHeight: imageHeight ?? this.imageHeight,
//       );
// }
