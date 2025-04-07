// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:mybete_app/have_diabetes/DashBoard/profile/change_password_screen.dart';
// import 'package:share_plus/share_plus.dart';
//
// class AccountSettingsScreen extends StatefulWidget {
//   @override
//   _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
// }
//
// class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
//   String firstName = "--";
//   String lastName = "--";
//   String dateOfBirth = "--";
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Header
//           Container(
//             width: double.infinity,
//             color: Color(0xFF89D0ED),
//             padding: EdgeInsets.only(top: 40, bottom: 15, left: 10, right: 20),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.black),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 Text(
//                   "Account & Settings",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: Container(
//               color: Color(0xFFFFFFFF),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Edit Profile section
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(vertical: 20),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Edit Profile",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           Stack(
//                             children: [
//                               Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                   border: Border.all(color: Colors.grey.shade300),
//                                   image: _profileImage != null
//                                       ? DecorationImage(
//                                     image: FileImage(_profileImage!),
//                                     fit: BoxFit.cover,
//                                   )
//                                       : null,
//                                 ),
//                               ),
//                               Positioned(
//                                 right: 0,
//                                 bottom: 0,
//                                 child: InkWell(
//                                   onTap: _pickImage,
//                                   child: Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(color: Colors.grey.shade300),
//                                     ),
//                                     child: Icon(Icons.camera_alt, size: 20),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Email section
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Email",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "thenujaasuntharesan@gmail.com",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//
//                           // First name
//                           _buildInfoField (
//                             title: "First name",
//                             value: firstName,
//                             onTap: () => _showNameInputDialog("First name"),
//                           ),
//
//                           // Last name
//                           _buildInfoField (
//                             title: "Last name",
//                             value: lastName,
//                             onTap: () => _showNameInputDialog("Last name"),
//                           ),
//
//                           // Date of Birth
//                           _buildInfoField (
//                             title: "Date of Birth",
//                             value: dateOfBirth,
//                             onTap: () => _selectDate(context),
//                           ),
//
//                           SizedBox(height: 30),
//
//                           // Change password
//                           InkWell(
//                             onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.lock_outline, color: Colors.black),
//                                 SizedBox(width: 15),
//                                 Text(
//                                   "Change password",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 25),
//
//                           // Log out
//                           InkWell(
//                             onTap: () {
//                               // Handle logout
//                             },
//                             child: Row(
//                               children: [
//                                 Icon(Icons.logout, color: Colors.red),
//                                 SizedBox(width: 15),
//                                 Text(
//                                   "Log out",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 25),
//
//                           // Delete account
//                           InkWell(
//                             onTap: () {
//                               // Handle account deletion
//                             },
//                             child: Row (
//                               children: [
//                                 Icon( Icons.delete_outline, color: Colors.red ),
//                                 SizedBox( width: 15 ),
//                                 Text(
//                                   "Delete my account",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoField({
//     required String title,
//     required String value,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 5),
//         InkWell(
//           onTap: onTap,
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }
//
//
//
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       print('Image selected: ${image.path}');
//       // You can update the state to store the image path
//       setState(() {
//         // Example: store image path in a variable
//         _imagePath = image.path;
//       });
//     } else {
//       print('No image selected');
//     }
//   }
//
// // Add a variable to store the image path
//   String? _imagePath;
//
//
//   void _showNameInputDialog (String field) {
//     TextEditingController controller = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Please enter your $field",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       labelText: field,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (field == "First name") {
//                           setState(() {
//                             firstName = controller.text.isNotEmpty ? controller.text : "--";
//                           });
//                         } else if (field == "Last name") {
//                           setState(() {
//                             lastName = controller.text.isNotEmpty ? controller.text : "--";
//                           });
//                         }
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF89D0ED),
//                       ),
//                       child: Text("Save"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         dateOfBirth = "${picked.day}/${picked.month}/${picked.year}";
//       });
//     }
//   }
// }




import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mybete_app/have_diabetes/DashBoard/profile/change_password_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String firstName = "--";
  String lastName = "--";
  String dateOfBirth = "--";
  String email = "--";
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Set email from Firebase Auth
        setState(() {
          email = currentUser.email ?? "--";
        });

        // Get additional user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            firstName = userData['firstName'] ?? "--";
            lastName = userData['lastName'] ?? "--";
            dateOfBirth = userData['dateOfBirth'] ?? "--";
            _profileImageUrl = userData['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserData({
    String? newFirstName,
    String? newLastName,
    String? newDateOfBirth,
    String? newProfileImageUrl,
  }) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        Map<String, dynamic> dataToUpdate = {};

        if (newFirstName != null) dataToUpdate['firstName'] = newFirstName;
        if (newLastName != null) dataToUpdate['lastName'] = newLastName;
        if (newDateOfBirth != null) dataToUpdate['dateOfBirth'] = newDateOfBirth;
        if (newProfileImageUrl != null) dataToUpdate['profileImageUrl'] = newProfileImageUrl;

        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .set(dataToUpdate, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Color(0xFF89D0ED),
            padding: EdgeInsets.only(top: 40, bottom: 15, left: 10, right: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Account & Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF89D0ED)))
                : Container(
              color: Color(0xFFFFFFFF),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Edit Profile section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  image: _profileImage != null
                                      ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                      : _profileImageUrl != null
                                      ? DecorationImage(
                                    image: NetworkImage(_profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: (_profileImage == null && _profileImageUrl == null)
                                    ? Icon(Icons.person, size: 50, color: Colors.grey)
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Icon(Icons.camera_alt, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Email section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),

                          // First name
                          _buildInfoField(
                            title: "First name",
                            value: firstName,
                            onTap: () => _showNameInputDialog("First name"),
                          ),

                          // Last name
                          _buildInfoField(
                            title: "Last name",
                            value: lastName,
                            onTap: () => _showNameInputDialog("Last name"),
                          ),

                          // Date of Birth
                          _buildInfoField(
                            title: "Date of Birth",
                            value: dateOfBirth,
                            onTap: () => _selectDate(context),
                          ),

                          SizedBox(height: 30),

                          // Change password
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline, color: Colors.black),
                                SizedBox(width: 15),
                                Text(
                                  "Change password",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 25),

                          // Log out
                          InkWell(
                            onTap: _signOut,
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red),
                                SizedBox(width: 15),
                                Text(
                                  "Log out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 25),

                          // Delete account
                          InkWell(
                            onTap: _showDeleteAccountConfirmation,
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 15),
                                Text(
                                  "Delete my account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });

      // Upload image to Firebase Storage
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploading image...'))
      );

      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${currentUser.uid}.jpg');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(_profileImage!);

      // Get download URL after upload completes
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update profile image URL in Firestore
      await _updateUserData(newProfileImageUrl: downloadUrl);

      // Update state
      setState(() {
        _profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully'))
      );
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e'))
      );
    }
  }

  void _showNameInputDialog(String field) {
    TextEditingController controller = TextEditingController();

    // Set initial value based on field
    if (field == "First name") {
      controller.text = firstName != "--" ? firstName : "";
    } else if (field == "Last name") {
      controller.text = lastName != "--" ? lastName : "";
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enter your $field",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: field,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        String newValue = controller.text.isNotEmpty ? controller.text : "--";

                        if (field == "First name") {
                          setState(() {
                            firstName = newValue;
                          });
                          await _updateUserData(newFirstName: newValue != "--" ? newValue : null);
                        } else if (field == "Last name") {
                          setState(() {
                            lastName = newValue;
                          });
                          await _updateUserData(newLastName: newValue != "--" ? newValue : null);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF89D0ED),
                      ),
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}/${picked.month}/${picked.year}";

      setState(() {
        dateOfBirth = formattedDate;
      });

      await _updateUserData(newDateOfBirth: formattedDate);
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to login screen or handle sign out in your app
      // For example:
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      //   (route) => false,
      // );
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteAccount();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(currentUser.uid).delete();

        // Delete profile image from Storage if exists
        if (_profileImageUrl != null) {
          await _storage.refFromURL(_profileImageUrl!).delete();
        }

        // Delete the user account
        await currentUser.delete();

        // Navigate to login screen or handle account deletion in your app
        // For example:
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        //   (route) => false,
        // );
      }
    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e. You may need to re-authenticate.')),
      );
    }
  }
}