import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload an image file to Firebase Storage
  Future<String> uploadImageFile(File imageFile) async {
    try {
      final fileName = path.basename(imageFile.path);
      final destination = 'property_images/$fileName';
      
      final ref = _storage.ref().child(destination);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  // Upload images from assets for initial setup
  Future<String> uploadAssetImage(String assetPath, String fileName) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      
      final destination = 'property_images/$fileName';
      final ref = _storage.ref().child(destination);
      
      final uploadTask = ref.putData(bytes);
      final snapshot = await uploadTask.whenComplete(() {});
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload asset image: $e');
    }
  }
  
  // Helper method to upload the four house images included in the app
  Future<List<String>> uploadSampleHouseImages() async {
  try {
    final List<String> assetPaths = [
      'assets/images/house1.jpg',
      'assets/images/house2.jpg',
      'assets/images/house3.jpg',
      'assets/images/house4.jpg',
    ];
    
    final List<String> imageUrls = [];
    
    for (int i = 0; i < assetPaths.length; i++) {
      print("Uploading image: ${assetPaths[i]}");
      final url = await uploadAssetImage(assetPaths[i], 'house${i + 1}.jpg');
      print("Uploaded successfully. URL: $url");
      imageUrls.add(url);
    }
    
    return imageUrls;
  } catch (e) {
    print("Error uploading sample house images: $e");
    throw e;
  }
}
}