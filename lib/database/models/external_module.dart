import 'package:lunasea/core.dart';

part 'external_module.g.dart';

@JsonSerializable()
@HiveType(typeId: 26, adapterName: 'LunaExternalModuleAdapter')
class LunaExternalModule extends HiveObject {
  @JsonKey()
  @HiveField(0, defaultValue: '')
  String displayName;

  @JsonKey()
  @HiveField(1, defaultValue: '')
  String host;

  @JsonKey()
  @HiveField(2, defaultValue: <String, String>{})
  Map<String, String> headers;

  LunaExternalModule._internal({
    required this.displayName,
    required this.host,
    required this.headers,
  });

  factory LunaExternalModule({
    String? displayName,
    String? host,
    Map<String, String>? headers,
  }) {
    return LunaExternalModule._internal(
        displayName: displayName ?? '',
        host: host ?? '',
      headers: headers ?? {},
    );
  }

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() => _$LunaExternalModuleToJson(this);

  factory LunaExternalModule.fromJson(Map<String, dynamic> json) {
    return _$LunaExternalModuleFromJson(json);
  }

  factory LunaExternalModule.clone(LunaExternalModule profile) {
    return LunaExternalModule.fromJson(profile.toJson());
  }

  factory LunaExternalModule.get(String key) {
    return LunaBox.externalModules.read(key)!;
  }
}
