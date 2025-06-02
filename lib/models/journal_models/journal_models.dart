class JournalModels {
  int? entriesId;
  String? content;
  String? attachment;
  String? title;
  String? createdAt;
  String? updatedAt;

  JournalModels({
    this.entriesId,
    this.content,
    this.attachment,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory JournalModels.fromJson(Map<String, dynamic> json) => JournalModels(
        entriesId: json['entriesID'] as int?,
        content: json['content'] as String?,
        attachment: json['attachment'] as String?,
        title: json['title'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'entriesID': entriesId,
        'content': content,
        'attachment': attachment,
        'title': title,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  static List<JournalModels> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JournalModels.fromJson(json)).toList();
  }
}
