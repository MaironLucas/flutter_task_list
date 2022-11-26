import 'package:flutter_task_list/data/cache/model/character.dart';
import 'package:flutter_task_list/data/model/character.dart';

extension CharacterDMtoCM on Character {
  CharacterCM toCM() => CharacterCM(
        id: id,
        name: name,
        image: image,
      );
}
