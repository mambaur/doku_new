class TransactionModel{
  int? id, nominal, categoryId;
  String? date, notes, createdAt, updatedAt;

  TransactionModel({this.id, this.nominal, this.categoryId, this.date, this.notes, this.createdAt, this.updatedAt});

  factory TransactionModel.fromJson(Map<String, dynamic> json){
    return TransactionModel(
      id: json['id'],
      nominal: json['nominal'],
      categoryId: json['category_id'],
      date: json['date'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nominal'] = nominal;
    data['category_id'] = categoryId;
    data['date'] = date;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}