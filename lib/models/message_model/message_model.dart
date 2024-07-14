class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  String? audioPath; // New property for audio message

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    this.text,
    this.audioPath, // Initialize audioPath with null
  });

  // When receiving data from a map
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    audioPath = json['audioPath']; // Deserialize audioPath
  }

  // When sending data as a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text,
      'audioPath': audioPath, // Serialize audioPath
    };
  }
}

