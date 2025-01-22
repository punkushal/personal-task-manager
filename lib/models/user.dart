class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({required this.email, required this.uid, required this.name});

  //To convert from json to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      uid: json['uid'],
      name: json['displayName'],
    );
  }

  //To convert from User object to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
