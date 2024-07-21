class Momo {
  String category;
  String descripcion;
  int id;
  String image;
  String name;

  Momo({
    required this.category,
    required this.descripcion,
    required this.id,
    required this.image,
    required this.name,
  });

  factory Momo.fromJson(Map<String, dynamic> json) {
    return Momo(
      category: json['category'] as String,
      descripcion: (json['descripcion'] as String?) ?? "",
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
    );
  }
}
