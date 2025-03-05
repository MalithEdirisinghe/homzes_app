import '../models/property.dart';
import '../services/firebase_service.dart';
import '../services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyRepository {
  final FirebaseService _firebaseService;
  final ImageService _imageService = ImageService();
  bool _assetsUploaded = false;

  PropertyRepository(this._firebaseService);

  Stream<List<Property>> getAllProperties() {
    return _firebaseService.getAllProperties();
  }

  Stream<List<Property>> getFeaturedProperties() {
    return _firebaseService.getFeaturedProperties();
  }

  Stream<List<Property>> getNewOfferProperties() {
    return _firebaseService.getNewOfferProperties();
  }

  Stream<List<Property>> getPopularRentProperties() {
    return _firebaseService.getPopularRentProperties();
  }
  
  // New integrated method that uploads images then adds data
  Future<void> addSampleData() async {
    try {
      // Only upload images once (to avoid duplicates)
      if (!_assetsUploaded) {
        // Upload images to Firebase Storage and get URLs
        final List<String> imageUrls = await _imageService.uploadSampleHouseImages();
        _assetsUploaded = true;
        
        // Generate sample properties with real Storage URLs
        final List<Map<String, dynamic>> sampleProperties = [
          {
            'title': 'Modern Luxury Villa',
            'image': imageUrls[0], // Use actual Firebase Storage URL
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
            'image': imageUrls[1], 
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
            'image': imageUrls[2],
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
            'image': imageUrls[3],
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
        
        // Add the sample properties to Firestore
        await _firebaseService.addSampleData();
        
        print("Sample data added with Firebase Storage URLs!");
      } else {
        // If images already uploaded, just add sample data with existing URLs
        await _firebaseService.addSampleData();
        print("Sample data added (images were already uploaded)");
      }
    } catch (e) {
      print("Error in adding sample data: $e");
      throw Exception('Failed to add sample data: $e');
    }
  }
}