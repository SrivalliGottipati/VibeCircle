import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final int id;
  final String name;
  final String? tagline;
  final String? description;
  final String imageUrl;
  final String? iconUrl;

  const Experience({
    required this.id,
    required this.name,
    this.tagline,
    this.description,
    required this.imageUrl,
    this.iconUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    tagline: json['tagline'],
    description: json['description'],
    imageUrl: json['image_url'] ?? '',
    iconUrl: json['icon_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'description': description,
    'image_url': imageUrl,
    'icon_url': iconUrl,
  };

  @override
  List<Object?> get props => [id, name, imageUrl, tagline, description, iconUrl];
}
