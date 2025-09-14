part of 'entities.dart';

class CategoryEntity {
  final String slug;
  final String name;
  final String url;

  CategoryEntity({required this.slug, required this.name, required this.url});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryEntity &&
        other.slug == slug &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => slug.hashCode ^ name.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'CategoryEntity(slug: $slug, name: $name, url: $url)';
  }
}
