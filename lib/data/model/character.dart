class Character {
  Character({
    required this.id,
    required this.name,
    required this.image,
  });

  final String name;
  final int id;
  final String image;

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );
}
