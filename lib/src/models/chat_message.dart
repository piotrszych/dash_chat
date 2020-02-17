part of dash_chat;

/// A message data structure used by dash_chat to handle messages
/// as well as quick replies.
class ChatMessage {
  /// ID of the message.
  ///
  /// If no ID is supplied, a new ID is assigned using a [Uuid.v4] method.
  /// This behaviour could be overridden by providing an *optional*
  /// parameter `messageIdGenerator`.
  ///
  /// This parameter is *required*.
  String id;

  /// Actual text of the message.
  String text;

  /// Message delivery time.
  ///
  /// Specifies the time the message was delivered.
  ///
  /// This parameter is *optional*. If no value is provided,
  /// the [DateTime.now] value will be used.
  DateTime createdAt;

  /// An [ChatUser] object describing the user who sent the message.
  ///
  /// It's used to distinguish between users and provide user's name and avatar.
  ///
  /// This parameter is *required*.
  ChatUser user;

  /// URL to the message's image.
  ///
  /// The value is **not** validated in the constructor nor anywhere else
  /// in the [ChatMessage] object.
  ///
  /// This parameter is *optional*.
  String image;

  /// URL to the message's video.
  ///
  /// The value is **not** validated in the constructor nor anywhere else
  /// in the [ChatMessage] object.
  ///
  /// This parameter is *optional*.
  String video;

  /// [QuickReplies] available for this [ChatMessage].
  ///
  /// This parameter is *optional*.
  QuickReplies quickReplies;

  ChatMessage({
    String id,
    @required this.text,
    @required this.user,
    this.image,
    this.video,
    this.quickReplies,
    String Function() messageIdGenerator,
    DateTime createdAt,
  }) {
    this.createdAt = createdAt != null ? createdAt : DateTime.now();
    this.id = id != null
        ? id
        : messageIdGenerator != null
            ? messageIdGenerator()
            : Uuid().v4().toString();
  }

  ChatMessage.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    text = json['text'];
    image = json['image'];
    // 'vedio' key kept for backwards compatibility
    video = json['video'] ?? json['vedio'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
    user = ChatUser.fromJson(json['user']);
    quickReplies = json['quickReplies'] != null
        ? QuickReplies.fromJson(json['quickReplies'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    try {
      data['id'] = this.id;
      data['text'] = this.text;
      data['image'] = this.image;
      data['video'] = this.video;
      data['createdAt'] = this.createdAt.millisecondsSinceEpoch;
      data['user'] = user.toJson();
      data['quickReplies'] = quickReplies.toJson();
    } catch (e) {
      print(e);
    }
    return data;
  }
}
