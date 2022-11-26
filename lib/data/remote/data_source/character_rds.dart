import 'package:dio/dio.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/model/character.dart';

class CharacterRDS {
  static String baseUrl = 'https://akabab.github.io/starwars-api/api';

  Future<Character> getCharacterById(int id) async {
    try {
      final json = await Dio().get(
        '$baseUrl/id/$id.json',
      );
      return Character.fromJson(json.data as Map<String, dynamic>);
    } catch (e) {
      throw InternalException();
    }
  }

  Future<List<Character>> getCharacterList() async {
    try {
      final json = await Dio().get('$baseUrl/all.json');
      final result = (json.data as List<Map<String, dynamic>>)
          .map<Character>(
            (characterJson) => Character.fromJson(characterJson),
          )
          .toList();
      return result;
    } catch (e) {
      throw InternalException();
    }
  }
}
