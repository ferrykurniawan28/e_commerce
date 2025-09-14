part of 'entities.dart';

class ReviewEntity {
  final int rating;
  final String? comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  ReviewEntity({
    required this.rating,
    this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewEntity &&
        other.rating == rating &&
        other.comment == comment &&
        other.date == date &&
        other.reviewerName == reviewerName &&
        other.reviewerEmail == reviewerEmail;
  }

  @override
  int get hashCode =>
      rating.hashCode ^
      comment.hashCode ^
      date.hashCode ^
      reviewerName.hashCode ^
      reviewerEmail.hashCode;
}
