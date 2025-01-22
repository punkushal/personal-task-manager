class User {
  final String uid;
  final String email;
  final String name;

  User({required this.email, required this.uid, required this.name});

  //To convert from json to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
