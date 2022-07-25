class BaseRequest {
  BaseRequest();

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    return data;
  }

  List<Map<String, dynamic>> toJsonList() {
    var data = <Map<String, dynamic>>[];
    return data;
  }
}
