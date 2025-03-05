import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'logic/blocs/properties/properties_bloc.dart';
import 'data/repositories/property_repository.dart';
import 'data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    print("Signed in anonymously to Firebase");
  } catch (e) {
    print("Anonymous sign-in failed: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  print("Firebase initialized successfully: ${Firebase.apps.length > 0}");
  
  await signInAnonymously();
  
  final firebaseService = FirebaseService();
  final propertyRepository = PropertyRepository(firebaseService);
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PropertiesBloc(propertyRepository),
        ),
      ],
      child: const HomzesApp(),
    ),
  );
}