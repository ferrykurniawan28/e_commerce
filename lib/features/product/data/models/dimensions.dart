part of 'models.dart';

class DimensionsModel extends Equatable {
  final double width;
  final double height;
  final double depth;

  const DimensionsModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height, 'depth': depth};
  }

  DimensionsEntity toEntity() {
    return DimensionsEntity(width: width, height: height, depth: depth);
  }

  @override
  List<Object> get props => [width, height, depth];
}
