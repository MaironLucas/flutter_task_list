import 'package:flutter_task_list/data/cache/data_source/character_cds.dart';
import 'package:flutter_task_list/data/mappers/cache_to_domain.dart';
import 'package:flutter_task_list/data/mappers/domain_to_cache.dart';
import 'package:flutter_task_list/data/model/character.dart';
import 'package:flutter_task_list/data/remote/data_source/character_rds.dart';

class CharacterRepository {
  CharacterRepository({
    required this.characterRDS,
    required this.characterCDS,
  });

  final CharacterRDS characterRDS;
  final CharacterCDS characterCDS;

  Future<Character> getCharacterById(int id) async {
    try {
      final characterCM = await characterCDS.getCharacterById(id);
      return characterCM.toDM();
    } catch (e) {
      await characterRDS.getCharacterList().then(
        (characterList) {
          characterCDS.upsertCharacterList(
            characterList.map((character) => character.toCM()).toList(),
          );
        },
      );
      final characterCM = await characterCDS.getCharacterById(id);
      return characterCM.toDM();
    }
  }
}
