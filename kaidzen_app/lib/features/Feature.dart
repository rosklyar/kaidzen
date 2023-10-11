import 'FeaturesRepository.dart';

class Feature {
  final int id;
  final String name;
  final bool discovered;

  Feature({required this.id, required this.name, required this.discovered});

  static Map<String, Object?> toMap(Feature announcement) {
    return {
      columnFeatureId: announcement.id,
      columnFeatureName: announcement.name,
      columnFeatureDiscovered: announcement.discovered,
    };
  }

  static Feature fromMap(Map<String, dynamic> map) {
    return Feature(
      id: map[columnFeatureId] as int,
      name: map[columnFeatureName] as String,
      discovered: map[columnFeatureDiscovered] == 1,
    );
  }

  @override
  String toString() {
    return 'Feature{id: $id, name: $name, discovered: $discovered}';
  }
}
