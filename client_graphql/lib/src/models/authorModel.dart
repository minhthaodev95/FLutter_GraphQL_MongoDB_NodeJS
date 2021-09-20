class Author {
  String name;
  int age;
  String id;

  Author({required this.age, required this.id, required this.name});
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(age: json['age'], id: json['id'], name: json['name']);
  }
}
