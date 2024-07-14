class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    required this.name,
    required this.email,
    required this.image,
    required this.cover,
    required this.phone,
    required this.bio,
    required this.isEmailVerified,
    required this.uId,
  });


  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'bio': bio,
      'phone': phone,
      'email': email,
      'cover': cover,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
    };
  }
}
