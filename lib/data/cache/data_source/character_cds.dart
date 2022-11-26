import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/cache/model/character.dart';
import 'package:hive/hive.dart';

class CharacterCDS {
  static const _characterListBoxKey = 'characterListBoxKey';

  Future<void> upsertCharacterList(List<CharacterCM> characterList) async {
    final box = await Hive.openBox<List>(_characterListBoxKey);

    await box.putAll({
      0: characterList,
    });
  }

  Future<List<CharacterCM>> getCharacterList() async {
    final box = await Hive.openBox<List>(_characterListBoxKey);

    return List<CharacterCM>.from(
      box.get(0)!,
    );
  }

  Future<CharacterCM> getCharacterById(int id) async {
    final cineList = await getCharacterList();
    return cineList.firstWhere(
      (character) => character.id == id,
      orElse: () => throw ObjectNotFoundException(),
    );
  }
}
