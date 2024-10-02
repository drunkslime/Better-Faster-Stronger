
class UserData {
  
  String name;
  String gender;
  int age;
  int height;
  int weight;

  UserData({
    required this.name,
    required this.gender, 
    required this.age, 
    required this.height, 
    required this.weight}
  );

  Map<String, dynamic> get map => {
    'name': name,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight
  };

}