import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseInitializationCheck extends StatelessWidget {
  const FirebaseInitializationCheck({Key? key}) : super(key: key);

  // Create a Future that resolves to the Firebase options
  Future<FirebaseOptions> _getFirebaseOptions() async {
    return Firebase.app().options;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseOptions>(
      future: _getFirebaseOptions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Firebase initialization error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final options = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Firebase is properly initialized with:'),
                Text('Project ID: ${options.projectId}'),
                Text('API Key: ${options.apiKey.substring(0, 5)}...'),
                const Text('You can now use Firestore and other Firebase services.'),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Firebase is not properly initialized.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        }

        return const CircularProgressIndicator();
      },
    );
  }
}