class CommentModel {
  final String? commentId;
  final String? description;

  CommentModel({
    required this.commentId,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'description': description,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'description': description,
    };
  }
}
