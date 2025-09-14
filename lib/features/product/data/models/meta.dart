part of 'models.dart';

@HiveType(typeId: 2)
class MetaModel extends Equatable {
  @HiveField(0)
  final DateTime createdAt;
  @HiveField(1)
  final DateTime updatedAt;
  @HiveField(2)
  final String barcode;
  @HiveField(3)
  final String qrCode;

  const MetaModel({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      barcode: json['barcode'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }

  MetaEntity toEntity() {
    return MetaEntity(
      createdAt: createdAt,
      updatedAt: updatedAt,
      barcode: barcode,
      qrCode: qrCode,
    );
  }

  @override
  List<Object> get props => [createdAt, updatedAt, barcode, qrCode];
}
