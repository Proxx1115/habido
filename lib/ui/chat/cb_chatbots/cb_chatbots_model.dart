class CBChatBotsModel {
  String? cbId;
  String? name;
  String? cbType;

  CBChatBotsModel({
    this.cbId,
    this.name,
    this.cbType,
  });

  CBChatBotsModel.fromJson(Map<dynamic, dynamic> json) {
    print("erdene erdene " + json["cbId"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cbId'] = cbId;
    map['name'] = name;
    map['cbType'] = cbType;
    return map;
  }
}
