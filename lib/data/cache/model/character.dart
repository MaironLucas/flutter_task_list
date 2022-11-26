import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 1)
class CharacterCM {
  CharacterCM({
    required this.id,
    required this.name,
    required this.image,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String image;
}
