class CategoryModel
{
  final String id;
  final String name;
  final String image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromFirestore(String  documentID, Map <String,dynamic>data)
  {
    return CategoryModel(id: documentID, name: data['name']??'', image: data['image']??'');
  }

  Map<String,dynamic>toMap()
  {
    return {'name': name, 'image':image};
  }
}