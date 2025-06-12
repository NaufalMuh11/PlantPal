import 'package:flutter/material.dart';
import 'package:plants_app/constants.dart';
import 'package:plants_app/model/profile.dart'; // Import the profile model

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool _isEditing = false;
  bool _isLoading = true;
  late Profile _profile;

  // Temporary variables for editing
  String _tempName = '';
  String _tempEmail = '';
  String _tempPhone = '';
  String _tempAddress = '';
  String _tempBio = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await Profile.loadProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load profile');
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _tempName = _profile.name;
      _tempEmail = _profile.email;
      _tempPhone = _profile.phone;
      _tempAddress = _profile.address;
      _tempBio = _profile.bio;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _saveProfile() async {
    // Validate inputs
    if (_tempName.trim().isEmpty) {
      _showErrorSnackBar('Name cannot be empty');
      return;
    }

    if (_tempEmail.trim().isEmpty) {
      _showErrorSnackBar('Email cannot be empty');
      return;
    }

    // Create updated profile
    final updatedProfile = _profile.copyWith(
      name: _tempName.trim(),
      email: _tempEmail.trim(),
      phone: _tempPhone.trim(),
      address: _tempAddress.trim(),
      bio: _tempBio.trim(),
    );

    // Validate email format
    if (!updatedProfile.isEmailValid()) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    // Save profile
    final success = await updatedProfile.saveProfile();

    if (success) {
      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
      });
      _showSuccessSnackBar('Profile updated successfully!');
    } else {
      _showErrorSnackBar('Failed to save profile');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Constants.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Constants.blackColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'My Profile',
            style: TextStyle(
              color: Constants.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Constants.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Constants.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: _cancelEditing,
            ),
            IconButton(
              icon: Icon(Icons.check, color: Constants.primaryColor),
              onPressed: _saveProfile,
            ),
          ] else
            IconButton(
              icon: Icon(Icons.edit, color: Constants.primaryColor),
              onPressed: _startEditing,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Image Section
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constants.primaryColor.withOpacity(.5),
                        width: 4.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.transparent,
                      backgroundImage: ExactAssetImage(
                        _profile.profileImagePath,
                      ),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.primaryColor,
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _profile.name,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_profile.isVerified)
                    SizedBox(
                      height: 24.0,
                      child: Image.asset("assets/images/verified.png"),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                'Member since ${_profile.getFormattedJoinDate()}',
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              // Profile Completion Indicator
              if (!_isEditing &&
                  _profile.getProfileCompletionPercentage() < 100)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile ${_profile.getProfileCompletionPercentage().toStringAsFixed(0)}% Complete',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Complete your profile to get better recommendations',
                              style: TextStyle(
                                color: Colors.orange.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Profile Information Cards
              _buildProfileCard(
                icon: Icons.person_outline,
                title: 'Full Name',
                value: _isEditing ? _tempName : _profile.name,
                onChanged:
                    _isEditing
                        ? (value) => setState(() => _tempName = value)
                        : null,
              ),

              _buildProfileCard(
                icon: Icons.email_outlined,
                title: 'Email',
                value: _isEditing ? _tempEmail : _profile.email,
                onChanged:
                    _isEditing
                        ? (value) => setState(() => _tempEmail = value)
                        : null,
              ),

              _buildProfileCard(
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: _isEditing ? _tempPhone : _profile.phone,
                onChanged:
                    _isEditing
                        ? (value) => setState(() => _tempPhone = value)
                        : null,
              ),

              _buildProfileCard(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: _isEditing ? _tempAddress : _profile.address,
                onChanged:
                    _isEditing
                        ? (value) => setState(() => _tempAddress = value)
                        : null,
              ),

              _buildProfileCard(
                icon: Icons.info_outline,
                title: 'Bio',
                value: _isEditing ? _tempBio : _profile.bio,
                onChanged:
                    _isEditing
                        ? (value) => setState(() => _tempBio = value)
                        : null,
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              // Statistics Section
              _buildStatisticsSection(),

              const SizedBox(height: 30),

              // Action Buttons
              if (!_isEditing) ...[
                _buildActionButton(
                  icon: Icons.settings_outlined,
                  title: 'Account Settings',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String value,
    Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Constants.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.blackColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                onChanged != null
                    ? TextField(
                      onChanged: onChanged,
                      maxLines: maxLines,
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: 'Enter $title',
                      ),
                      controller: TextEditingController(text: value)
                        ..selection = TextSelection.collapsed(
                          offset: value.length,
                        ),
                    )
                    : Text(
                      value.isEmpty ? 'Not specified' : value,
                      style: TextStyle(
                        color:
                            value.isEmpty
                                ? Constants.blackColor.withOpacity(0.4)
                                : Constants.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            value.isEmpty ? FontStyle.italic : FontStyle.normal,
                      ),
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Plants Owned', _profile.plantsOwned.toString()),
          _buildStatItem('Days Active', _profile.daysActive.toString()),
          _buildStatItem('Plants Saved', _profile.plantsSaved.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Constants.blackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Constants.blackColor.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Constants.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Constants.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Constants.blackColor.withOpacity(0.3),
          size: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      ),
    );
  }
}
