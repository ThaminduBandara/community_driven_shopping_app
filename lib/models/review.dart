class Review {
  final String userId;
  final String username;
  final double rating;
  final String comment;
  final double? serviceRating;
  final DateTime createdAt;

  Review({
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    this.serviceRating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'] as String,
      username: json['username'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      serviceRating: json['serviceRating'] != null 
          ? (json['serviceRating'] as num).toDouble() 
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'rating': rating,
      'comment': comment,
      if (serviceRating != null) 'serviceRating': serviceRating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
