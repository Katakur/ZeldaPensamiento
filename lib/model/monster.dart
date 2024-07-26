class Monster {
  String category;
  String description;
  int id;
  String image;
  String name;
  List<String> commonLocations;
  bool dlc;
  List<String>? drops; 
  bool favorite;

  Monster({
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.commonLocations,
    required this.dlc,
    this.drops,
    required this.favorite,
  });

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      category: json['category'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      commonLocations: json['common_locations'] != null ? List<String>.from(json['common_locations'] as List<dynamic>) : [], 
      dlc: json['dlc'] ?? false, 
      drops: json['drops'] != null ? List<String>.from(json['drops'] as List<dynamic>) : null,
      favorite: json['favorite'] ?? false,
    );
  }

  void cambiarSeleccionado() {
    favorite = !favorite;
  }
}

