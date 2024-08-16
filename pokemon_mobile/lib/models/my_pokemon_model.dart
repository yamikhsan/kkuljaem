class MyPokemonModel {
  final int id;
  final String name;
  final String nickname;
  final String image;
  final String? rename;
  final int countRename;

  MyPokemonModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.image,
    required this.countRename,
    this.rename,
  });

  factory MyPokemonModel.fromJson(Map<String, dynamic> json) => MyPokemonModel(
        id: json["id"],
        name: json["name"],
        nickname: json["nickname"],
        image: json["image"],
        countRename: json["count_rename"],
        rename: json["rename"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nickname": nickname,
        "image": image,
        "count_rename": countRename,
        "rename": rename,
      };
}
