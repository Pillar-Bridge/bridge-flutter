class DialogueMessage {
  final String messageId;
  final String text;
  final String speaker;
  final String createdAt;

  DialogueMessage({
    required this.messageId,
    required this.text,
    required this.speaker,
    required this.createdAt,
  });

  factory DialogueMessage.fromJson(Map<String, dynamic> json) {
    return DialogueMessage(
      messageId: json['messageId'],
      text: json['text'],
      speaker: json['speaker'],
      createdAt: json['createdAt'],
    );
  }
}

class Dialogue {
  final String dialogueId;
  final String place;
  final String situation;
  final List<DialogueMessage> messages;

  Dialogue({
    required this.dialogueId,
    required this.place,
    required this.situation,
    required this.messages,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    List<DialogueMessage> messages = (json['messages'] as List)
        .map((item) => DialogueMessage.fromJson(item))
        .toList();

    return Dialogue(
      dialogueId: json['dialogueId'],
      place: json['place'],
      situation: json['situation'] ?? "",
      messages: messages,
    );
  }
}
