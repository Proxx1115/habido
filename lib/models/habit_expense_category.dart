class HabitExpenseCategory {
  int? categoryId;
  int? userId;
  String? hdCategoryType;
  String? name;
  String? photo;
  String? photoBase64;
  String? color;
  int? orderNo;
  bool? isActive;
  bool? isFinance;

  HabitExpenseCategory({
      this.categoryId, 
      this.userId, 
      this.hdCategoryType, 
      this.name, 
      this.photo, 
      this.photoBase64, 
      this.color, 
      this.orderNo, 
      this.isActive, 
      this.isFinance});

  HabitExpenseCategory.fromJson(dynamic json) {
    categoryId = json['categoryId'];
    userId = json['userId'];
    hdCategoryType = json['hdCategoryType'];
    name = json['name'];
    photo = json['photo'];
    photoBase64 = json['photoBase64'];
    color = json['color'];
    orderNo = json['orderNo'];
    isActive = json['isActive'];
    isFinance = json['isFinance'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['userId'] = userId;
    map['hdCategoryType'] = hdCategoryType;
    map['name'] = name;
    map['photo'] = photo;
    map['photoBase64'] = photoBase64;
    map['color'] = color;
    map['orderNo'] = orderNo;
    map['isActive'] = isActive;
    map['isFinance'] = isFinance;
    return map;
  }

}