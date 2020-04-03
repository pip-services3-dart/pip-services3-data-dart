import 'package:pip_services3_commons/pip_services3_commons.dart';

class Dummy implements IStringIdentifiable {
  @override
  String id;
  String key;
  String content;

  Dummy(this.id, this.key, this.content);
  factory Dummy.fromJson(Map<String, dynamic> json) {
    return Dummy(json['id'], json['key'], json['content']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'key': key, 'content': content};
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    content = json['content'];
  }
}
