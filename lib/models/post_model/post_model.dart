import '../comment_model/comment_model.dart';

class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;
  List<CommentModel>? comments;
  List<String>? tags; // Add tags field

  PostModel({
    required this.name,
    required this.image,
    required this.uId,
    required this.postImage,
    required this.text,
    required this.dateTime,
    this.comments,
    this.tags, // Initialize tags field
  });

  // Constructor from JSON
  PostModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        uId = json['uId'],
        postImage = json['postImage'],
        text = json['text'],
        dateTime = json['dateTime'],
        comments = [], // Initialize comments as an empty list
        tags = json['tags'] != null ? List<String>.from(json['tags']) : [];

  // Convert to JSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'uId': uId,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'tags': tags, // Add tags to the map
    };
  }
}
