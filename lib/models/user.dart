class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({required this.email, required this.uid, required this.name});

  //To convert from json to User object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      uid: map['uid'],
      name: map['displayName'],
    );
  }

  //To convert from User object to json
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
