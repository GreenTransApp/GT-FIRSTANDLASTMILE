abstract class JsonConverters<T> {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}
