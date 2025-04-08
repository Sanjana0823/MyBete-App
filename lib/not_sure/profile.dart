import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? username, email, phone, age, gender;
  bool _isLoading = true;

  final Color primaryColor = const Color(0xFF5FB8DD);
  final Color secondaryColor = const Color(0xFF5EB7CF);
  final Color darkTextColor = const Color(0xFF333333);
  final Color lightTextColor = const Color(0xFF999999);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(_animationController);
    _animationController.forward();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      setState(() {
        username = userDoc["username"];
        email = userDoc["email"];
        phone = userDoc["phone"];
        age = userDoc["age"];
        gender = userDoc["gender"];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450, minHeight: screenSize.height * 0.8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 20.0 : 28.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Profile Picture with User Icon Overlay
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: isSmallScreen ? 50 : 60,
                                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                                  backgroundColor: secondaryColor.withOpacity(0.2),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: CircleAvatar(
                                    radius: isSmallScreen ? 18 : 22,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person, size: isSmallScreen ? 18 : 22, color: primaryColor),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 16 : 20),

                            Text(
                              username ?? "Loading...",
                              style: GoogleFonts.poppins(fontSize: isSmallScreen ? 22 : 24, fontWeight: FontWeight.bold, color: darkTextColor),
                            ),
                            Text(email ?? "", style: GoogleFonts.poppins(fontSize: isSmallScreen ? 14 : 16, color: lightTextColor)),

                            SizedBox(height: isSmallScreen ? 24 : 32),

                            _buildInfoTile(Icons.phone_outlined, "Phone", phone ?? "Loading..."),
                            _buildInfoTile(Icons.cake_outlined, "Age", age ?? "Loading..."),
                            _buildInfoTile(Icons.wc_outlined, "Gender", gender ?? "Loading..."),

                            SizedBox(height: isSmallScreen ? 24 : 32),

                            // Logout Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _logout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 4,
                                  shadowColor: Colors.red.withOpacity(0.5),
                                ),
                                child: Text("Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: isSmallScreen ? 15 : 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: darkTextColor)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 6),
          child: Text(value, style: GoogleFonts.poppins(fontSize: 14, color: lightTextColor)),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1.2, height: 24),
      ],
    );
  }
}
