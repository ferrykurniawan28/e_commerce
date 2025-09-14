part of 'models.dart';

@HiveType(typeId: 1)
class DimensionsModel extends Equatable {
  @HiveField(0)
  final double width;
  @HiveField(1)
  final double height;
  @HiveField(2)
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
