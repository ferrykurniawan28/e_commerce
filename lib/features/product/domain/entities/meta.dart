part of 'entities.dart';

class MetaEntity {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  MetaEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MetaEntity &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.barcode == barcode &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode =>
      createdAt.hashCode ^
      updatedAt.hashCode ^
      barcode.hashCode ^
      qrCode.hashCode;
}
