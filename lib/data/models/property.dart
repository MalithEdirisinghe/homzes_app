import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Property extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String location;
  final double price;
  final int numberOfBeds;
  final int numberOfBathrooms;
  final double? rating;
  final int? reviewCount;
  final bool isFeatured;
  final bool isNewOffer;
  final DateTime createdAt;

  const Property({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.numberOfBeds,
    required this.numberOfBathrooms,
    this.rating,
    this.reviewCount,
    this.isFeatured = false,
    this.isNewOffer = false,
    required this.createdAt,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['image'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      numberOfBeds: data['numberOfBeds'] ?? 0,
      numberOfBathrooms: data['numberOfBathrooms'] ?? 0,
      rating: data['rating']?.toDouble(),
      reviewCount: data['reviewCount'],
      isFeatured: data['isFeatured'] ?? false,
      isNewOffer: data['isNewOffer'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': imageUrl,
      'location': location,
      'price': price,
      'numberOfBeds': numberOfBeds,
      'numberOfBathrooms': numberOfBathrooms,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNewOffer': isNewOffer,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        location,
        price,
        numberOfBeds,
        numberOfBathrooms,
        rating,
        reviewCount,
        isFeatured,
        isNewOffer,
        createdAt,
      ];
}