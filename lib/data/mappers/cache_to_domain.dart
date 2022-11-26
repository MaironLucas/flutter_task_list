import 'package:flutter_task_list/data/cache/model/character.dart';
import 'package:flutter_task_list/data/model/character.dart';

extension CharacterCMtoDM on CharacterCM {
  Character toDM() => Character(
        id: id,
        name: name,
        image: image,
      );
}
