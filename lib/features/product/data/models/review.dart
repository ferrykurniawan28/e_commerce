part of 'models.dart';

class ReviewModel extends Equatable {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const ReviewModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      rating: rating,
      comment: comment,
      date: date,
      reviewerName: reviewerName,
      reviewerEmail: reviewerEmail,
    );
  }

  @override
  List<Object> get props => [
    rating,
    comment,
    date,
    reviewerName,
    reviewerEmail,
  ];
}
