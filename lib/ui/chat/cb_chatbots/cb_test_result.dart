class CBTestResult {
  int? cbTestResultId;
  int? cbId;
  String? point;
  String? resultText;
  String? description;

  CBTestResult({
    this.cbTestResultId,
    this.cbId,
    this.point,
    this.resultText,
    this.description,
  });

  CBTestResult.fromJson(dynamic json) {
    cbTestResultId = json['cbTestResultId'];
    cbId = json['cbId'];
    point = json['point'];
    resultText = json['resultText'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cbTestResultId'] = cbTestResultId;
    map['cbId'] = cbId;
    map['point'] = point;
    map['resultText'] = resultText;
    map['description'] = description;
    return map;
  }
}
