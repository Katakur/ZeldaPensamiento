class Equipment {
  String category;
  String description;
  int id;
  String image;
  String name;
  List<String> commonLocations; // Uncomment and use if you need this field
  bool dlc;
  EquipmentProperties? properties; // Make this nullable if it's not always present
  bool favorite;

  Equipment({
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.commonLocations, // Uncomment if you are using this field
    required this.dlc,
    this.properties, // Make it optional
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
          : [], // Provide an empty list if null
      dlc: json['dlc'] ?? false, // Provide a default value if null
      properties: json['properties'] != null 
          ? EquipmentProperties.fromJson(json['properties'] as Map<String, dynamic>) 
          : null, // Make properties optional
      favorite: json['favorite'] ?? false, // Provide a default value if null
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
      attack: json['attack'] ?? 0, // Provide a default value if null
      defense: json['defense'] ?? 0, // Provide a default value if null
    );
  }
}
