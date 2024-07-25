class Equipment {
  String category;
  String description;
  int id;
  String image;
  String name;
  //List<String> commonLocations;
  bool dlc;
  //EquipmentProperties properties;

  Equipment({
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    //required this.commonLocations,
    required this.dlc,
    //required this.properties,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      category: json['category'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      //commonLocations: List<String>.from(json['common_locations'] as List<dynamic>),
      dlc: json['dlc'] as bool,
      //properties: EquipmentProperties.fromJson(json['properties'] as Map<String, dynamic>),
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
      attack: json['attack'] as int,
      defense: json['defense'] as int,
    );
  }
}
