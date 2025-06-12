class Profile {
  String name;
  String email;
  String phone;
  String address;
  String bio;
  String profileImagePath;
  bool isVerified;
  DateTime joinDate;

  // Statistics
  int plantsOwned;
  int daysActive;
  int plantsSaved;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.bio,
    required this.profileImagePath,
    this.isVerified = false,
    required this.joinDate,
    this.plantsOwned = 0,
    this.daysActive = 0,
    this.plantsSaved = 0,
  });

  // Default user profile (singleton pattern)
  static Profile _currentUser = Profile(
    name: 'Dadang Korneto',
    email: 'iniemailsaya@gmail.com',
    phone: '+62 812 3456 7890',
    address: 'Jakarta, Indonesia',
    bio: 'Plant enthusiast and nature lover',
    profileImagePath: 'assets/images/verified.jpg',
    isVerified: true,
    joinDate: DateTime(2023, 6, 15),
    plantsOwned: 24,
    daysActive: 156,
    plantsSaved: 8,
  );

  // Get current user instance
  static Profile getCurrentUser() {
    return _currentUser;
  }

  // Update profile information
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? bio,
    String? profileImagePath,
  }) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    if (address != null) this.address = address;
    if (bio != null) this.bio = bio;
    if (profileImagePath != null) this.profileImagePath = profileImagePath;
  }

  // Update statistics
  void updateStatistics({int? plantsOwned, int? daysActive, int? plantsSaved}) {
    if (plantsOwned != null) this.plantsOwned = plantsOwned;
    if (daysActive != null) this.daysActive = daysActive;
    if (plantsSaved != null) this.plantsSaved = plantsSaved;
  }

  // Calculate days since joining
  int getDaysSinceJoining() {
    return DateTime.now().difference(joinDate).inDays;
  }

  // Get formatted join date
  String getFormattedJoinDate() {
    return '${joinDate.day}/${joinDate.month}/${joinDate.year}';
  }

  // Validate email format
  bool isEmailValid() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone format
  bool isPhoneValid() {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  // Check if profile is complete
  bool isProfileComplete() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        bio.isNotEmpty &&
        isEmailValid() &&
        isPhoneValid();
  }

  // Get profile completion percentage
  double getProfileCompletionPercentage() {
    int completedFields = 0;
    int totalFields = 5;

    if (name.isNotEmpty) completedFields++;
    if (email.isNotEmpty && isEmailValid()) completedFields++;
    if (phone.isNotEmpty && isPhoneValid()) completedFields++;
    if (address.isNotEmpty) completedFields++;
    if (bio.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  // Save profile (simulate saving to database/API)
  Future<bool> saveProfile() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Here you would typically save to a database or API
      // For now, we'll just update the singleton instance
      _currentUser = this;

      return true;
    } catch (e) {
      return false;
    }
  }

  // Load profile from storage (simulate loading from database/API)
  static Future<Profile> loadProfile() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Here you would typically load from a database or API
      // For now, we'll just return the singleton instance
      return _currentUser;
    } catch (e) {
      // Return default profile if loading fails
      return Profile(
        name: '',
        email: '',
        phone: '',
        address: '',
        bio: '',
        profileImagePath: 'assets/images/profile.jpg',
        joinDate: DateTime.now(),
      );
    }
  }

  // Convert to JSON (for API calls or local storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'bio': bio,
      'profileImagePath': profileImagePath,
      'isVerified': isVerified,
      'joinDate': joinDate.toIso8601String(),
      'plantsOwned': plantsOwned,
      'daysActive': daysActive,
      'plantsSaved': plantsSaved,
    };
  }

  // Create from JSON (for API calls or local storage)
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      bio: json['bio'] ?? '',
      profileImagePath: json['profileImagePath'] ?? 'assets/images/profile.jpg',
      isVerified: json['isVerified'] ?? false,
      joinDate: DateTime.parse(
        json['joinDate'] ?? DateTime.now().toIso8601String(),
      ),
      plantsOwned: json['plantsOwned'] ?? 0,
      daysActive: json['daysActive'] ?? 0,
      plantsSaved: json['plantsSaved'] ?? 0,
    );
  }

  // Copy with method for immutable updates
  Profile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? bio,
    String? profileImagePath,
    bool? isVerified,
    DateTime? joinDate,
    int? plantsOwned,
    int? daysActive,
    int? plantsSaved,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isVerified: isVerified ?? this.isVerified,
      joinDate: joinDate ?? this.joinDate,
      plantsOwned: plantsOwned ?? this.plantsOwned,
      daysActive: daysActive ?? this.daysActive,
      plantsSaved: plantsSaved ?? this.plantsSaved,
    );
  }

  @override
  String toString() {
    return 'Profile{name: $name, email: $email, phone: $phone, address: $address, bio: $bio}';
  }
}
