import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 2)
class Location {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });
}
