import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
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
                  "About myBete",
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
            child: Container(
              color: Color(0xFFFFFFFF),
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFD6EDF8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 50,
                          color: Color(0xFF89D0ED),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // App Version
                    Center(
                      child: Text(
                        "myBete v1.0.0",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // App Description
                    Text(
                      "About myBete",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89D0ED),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "myBete is a comprehensive diabetes management application designed to help users monitor and manage their diabetes effectively. The app provides tools for tracking blood glucose levels, medication, diet, and physical activity.",
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    SizedBox(height: 20),

                    // Features
                    Text(
                      "Key Features",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89D0ED),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildFeatureItem("Blood glucose tracking and monitoring"),
                    _buildFeatureItem("Medication reminders and logging"),
                    _buildFeatureItem("Diet and carbohydrate tracking"),
                    _buildFeatureItem("Physical activity monitoring"),
                    _buildFeatureItem("Comprehensive statistics and reports"),
                    _buildFeatureItem("Support and feedback system"),
                    SizedBox(height: 20),

                    // Contact Information
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89D0ED),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email: thenujaasuntharesan@gmail.com\nWebsite: www.mybete.com",
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    SizedBox(height: 30),

                    // Copyright
                    Center(
                      child: Text(
                        "© 2023 myBete. All rights reserved.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
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

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}