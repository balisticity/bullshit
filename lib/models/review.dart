class Review {
  final String productId;
  final String userEmail;
  final String userName;
  final double rating;
  final String comment;
  final int avatarIndex; // which preset avatar the user had when reviewing
  final DateTime createdAt;

  Review({
    required this.productId,
    required this.userEmail,
    required this.userName,
    required this.rating,
    required this.comment,
    this.avatarIndex = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'userEmail': userEmail,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'avatarIndex': avatarIndex,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    productId: json['productId'] as String,
    userEmail: json['userEmail'] as String,
    userName: json['userName'] as String,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String,
    avatarIndex: (json['avatarIndex'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
