class MessageDialogue {
  final String message_Id;
  final String speaker;
  final String message_text;

  MessageDialogue({
    required this.message_Id,
    required this.speaker,
    required this.message_text,
  });

  factory MessageDialogue.fromJson(Map<String, dynamic> json) {
    return MessageDialogue(
      message_Id: json['message_Id'],
      speaker: json['speaker'],
      message_text: json['message_text'],
    );
  }
}
