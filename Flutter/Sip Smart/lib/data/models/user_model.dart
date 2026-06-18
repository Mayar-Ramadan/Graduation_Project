class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String age;
  final String gender;
  final String weight;
  final String height;
  final String profileUrl;
  final String temperature;
  final String activityLevel;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.profileUrl,
    required this.temperature,
    required this.activityLevel,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      
   
      age: map['age']?.toString() ?? '',
      gender: map['gender'] ?? '',
      weight: map['weight']?.toString() ?? '',
      height: map['height']?.toString() ?? '',
      profileUrl: map['profile_url'] ?? '',
      temperature: map['temperature']?.toString() ?? '',
      
      activityLevel: map['activityLevel'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'profile_url': profileUrl,
      'temperature': temperature,
      'activityLevel': activityLevel,
    };
  }

  double _genderToNumber() {
    final value = gender.toLowerCase().trim();

    if (value == 'male') return 1;
    if (value == 'female') return 0;

    return 0;
  }

  double _activityLevelToNumber() {
    final value = activityLevel.toLowerCase().trim();

    if (value == 'low') return 0;
    if (value == 'medium') return 1;
    if (value == 'high') return 2;

    return 0;
  }

  List<double> toAiFeatures() {
    return [
      double.tryParse(age) ?? 0,
      _genderToNumber(),
      double.tryParse(temperature) ?? 0,
      _activityLevelToNumber(),
    ];
  }
}