class ConversationModel {
  final int id;
  final int createdBy;

  ConversationModel({
    required this.id,
    required this.createdBy,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      createdBy: json['created_by'],
    );
  }
}