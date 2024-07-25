class Treasure {
  String category;
  String description;
  int id;
  String image;
  String name;
  List<String> commonLocations;
  List<String> drops;
  bool dlc;

  Treasure({
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.commonLocations,
    required this.drops,
    required this.dlc,
  });

  factory Treasure.fromJson(Map<String, dynamic> json) {
    return Treasure(
      category: json['category'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      commonLocations: List<String>.from(json['common_locations'] as List<dynamic>),
      drops: List<String>.from(json['drops'] as List<dynamic>),
      dlc: json['dlc'] as bool,
    );
  }
}
