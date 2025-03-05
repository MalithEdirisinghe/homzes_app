import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';
import '../services/image_service.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageService _imageService = ImageService();
  final String _propertiesCollection = 'properties';

  // Get all properties
  Stream<List<Property>> getAllProperties() {
    return _firestore
        .collection(_propertiesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();
    });
  }

  // Get featured properties
Stream<List<Property>> getFeaturedProperties() {
  print("Requesting featured properties from Firestore");
  return _firestore
      .collection(_propertiesCollection)
      .where('isFeatured', isEqualTo: true)
      .limit(5)
      .snapshots()
      .map((snapshot) {
    print("Featured properties snapshot received, doc count: ${snapshot.docs.length}");
    return snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();
  });
}

  // Get new offer properties
  Stream<List<Property>> getNewOfferProperties() {
  print("Requesting new offer properties from Firestore");
  return _firestore
      .collection(_propertiesCollection)
      .where('isNewOffer', isEqualTo: true)
      // Remove the orderBy temporarily until index is created
      .limit(5)
      .snapshots()
      .map((snapshot) {
    print("New offer properties snapshot received, doc count: ${snapshot.docs.length}");
    return snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();
  });
}

Future<void> checkFirestoreData() async {
  try {
    final snapshot = await _firestore
        .collection(_propertiesCollection)
        .get();
    
    print("Direct Firestore check: ${snapshot.docs.length} documents found");
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      print("Sample document ID: ${doc.id}");
      print("Sample document fields: ${doc.data().keys.join(', ')}");
      print("isFeatured: ${doc.data()['isFeatured']}");
      print("isNewOffer: ${doc.data()['isNewOffer']}");
    }
  } catch (e) {
    print("Error checking Firestore directly: $e");
  }
}

  // Get popular rent properties
  Stream<List<Property>> getPopularRentProperties() {
    return _firestore
        .collection(_propertiesCollection)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();
    });
  }
  
  // Add sample data for testing
  Future<void> addSampleData() async {
    try {
      // First upload images to Firebase Storage
      print("Uploading images to Firebase Storage...");
      final List<String> imageUrls = await _imageService.uploadSampleHouseImages();
      print("Images uploaded successfully. URLs: $imageUrls");

      // Now create properties with actual image URLs
      final List<Map<String, dynamic>> sampleProperties = [
        {
          'title': 'Modern Luxury Villa',
          'image': imageUrls[0], // Actual Firebase Storage URL
          'location': 'Los Angeles, CA',
          'price': 1250,
          'numberOfBeds': 3,
          'numberOfBathrooms': 2,
          'rating': 4.9,
          'reviewCount': 29,
          'isFeatured': true,
          'isNewOffer': true,
          'createdAt': Timestamp.now(),
        },
        {
          'title': 'Contemporary White House',
          'image': imageUrls[1], // Actual Firebase Storage URL
          'location': 'Miami, FL',
          'price': 1430,
          'numberOfBeds': 2,
          'numberOfBathrooms': 2,
          'rating': 4.7,
          'reviewCount': 18,
          'isFeatured': false,
          'isNewOffer': true,
          'createdAt': Timestamp.now(),
        },
        {
          'title': 'Craftsman Style Home',
          'image': imageUrls[2], // Actual Firebase Storage URL
          'location': 'Seattle, WA',
          'price': 750,
          'numberOfBeds': 4,
          'numberOfBathrooms': 2,
          'rating': 4.8,
          'reviewCount': 24,
          'isFeatured': true,
          'isNewOffer': false,
          'createdAt': Timestamp.now(),
        },
        {
          'title': 'Modern Glass Residence',
          'image': imageUrls[3], // Actual Firebase Storage URL
          'location': 'Austin, TX',
          'price': 1580,
          'numberOfBeds': 3,
          'numberOfBathrooms': 2,
          'rating': 4.5,
          'reviewCount': 12,
          'isFeatured': true,
          'isNewOffer': false,
          'createdAt': Timestamp.now(),
        },
      ];

      final batch = _firestore.batch();
      
      for (final property in sampleProperties) {
        final docRef = _firestore.collection(_propertiesCollection).doc();
        batch.set(docRef, property);
      }
      
      await batch.commit();
      print("Sample properties added to Firestore with actual image URLs");
    } catch (e) {
      print("Error in addSampleData: $e");
      throw e; // Re-throw to allow proper error handling
    }
  }
}