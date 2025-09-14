part of 'entities.dart';

class DimensionsEntity {
  final double width;
  final double height;
  final double depth;

  DimensionsEntity({
    required this.width,
    required this.height,
    required this.depth,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DimensionsEntity &&
        other.width == width &&
        other.height == height &&
        other.depth == depth;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ depth.hashCode;
}
