class Monster {
  String category;
  String descripcion;
  int id;
  String image;
  String name;

  Monster({
    required this.category,
    required this.descripcion,
    required this.id,
    required this.image,
    required this.name,
  });

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      category: json['category'] as String,
      descripcion: (json['descripcion'] as String?) ?? "",
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
    );
  }
}
