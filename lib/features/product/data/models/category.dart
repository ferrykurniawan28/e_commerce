part of 'models.dart';

class CategoryModel extends Equatable {
  final String slug;
  final String name;
  final String url;

  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'url': url};
  }

  CategoryEntity toEntity() {
    return CategoryEntity(slug: slug, name: name, url: url);
  }

  @override
  List<Object> get props => [slug, name, url];
}
