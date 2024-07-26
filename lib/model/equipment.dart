class Equipment {
  String category;
  String description;
  int id;
  String image;
  String name;
  List<String> commonLocations; 
  bool dlc;
  EquipmentProperties? properties; 
  bool favorite;

  Equipment({
    required this.category,
    required this.description,
    required this.id, 
    required this.image,
    required this.name,
    required this.commonLocations, 
    required this.dlc,
    this.properties, 
    required this.favorite,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      category: json['category'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      commonLocations: json['common_locations'] != null 
          ? List<String>.from(json['common_locations'] as List<dynamic>) 
          : [], 
      dlc: json['dlc'] ?? false, 
      properties: json['properties'] != null 
          ? EquipmentProperties.fromJson(json['properties'] as Map<String, dynamic>) 
          : null, 
      favorite: json['favorite'] ?? false, 
    );
  }
}

class EquipmentProperties {
  int attack;
  int defense;

  EquipmentProperties({
    required this.attack,
    required this.defense,
  });

  factory EquipmentProperties.fromJson(Map<String, dynamic> json) {
    return EquipmentProperties(
      attack: json['attack'] ?? 0, 
      defense: json['defense'] ?? 0,
    );
  }
}
