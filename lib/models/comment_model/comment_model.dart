class CommentModel {
  String? commenterName;
  String? commenterId;
  String? commentText;
  String? commentDateTime;

  CommentModel({
    required this.commenterName,
    required this.commenterId,
    required this.commentText,
    required this.commentDateTime,
  });

  // Constructor from JSON
  CommentModel.fromJson(Map<String, dynamic> json)
      : commenterName = json['commenterName'],
        commenterId = json['commenterId'],
        commentText = json['commentText'],
        commentDateTime = json['commentDateTime'];

  // Convert to JSON
  Map<String, dynamic> toMap() {
    return {
      'commenterName': commenterName,
      'commenterId': commenterId,
      'commentText': commentText,
      'commentDateTime': commentDateTime,
    };
  }
}