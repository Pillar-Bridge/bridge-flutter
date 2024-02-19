class ModificationOption {
  final String word;
  final List<String> options;

  ModificationOption({required this.word, required this.options});

  factory ModificationOption.fromJson(Map<String, dynamic> json) {
    return ModificationOption(
      word: json['word'],
      options: List<String>.from(json['options']),
    );
  }
}
