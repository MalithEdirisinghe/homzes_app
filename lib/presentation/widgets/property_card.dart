import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final bool isFeatured;
  final bool isHorizontal;
  final double width;
  final double height;
  final bool showLocation;
  final bool showRating;
  final bool showFavorite;

  const PropertyCard({
    Key? key,
    required this.property,
    this.isFeatured = false,
    this.isHorizontal = true,
    this.width = 200,
    this.height = 230,
    this.showLocation = true,
    this.showRating = true,
    this.showFavorite = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PropertyCard building: ${property.title} with image: ${property.imageUrl}");

    final bool isValidImageUrl = property.imageUrl.isNotEmpty && 
                               (property.imageUrl.startsWith('http') || 
                                property.imageUrl.startsWith('assets/'));
    
    print("PropertyCard image URL valid: $isValidImageUrl");

    if (isHorizontal) {
      return _buildHorizontalCard();
    } else {
      return _buildVerticalCard();
    }
  }

Widget buildPropertyImage() {
  print("Building image for: ${property.title}, URL: ${property.imageUrl}");
  
  if (property.imageUrl.startsWith('http')) {
    // Network image
    return Image.network(
      property.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading network image: $error");
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  } else if (property.imageUrl.startsWith('assets/')) {
    // Asset image
    return Image.asset(
      property.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading asset image: $error");
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        );
      },
    );
  } else {
    // Invalid or empty URL
    print("Invalid image URL: ${property.imageUrl}");
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 50),
    );
  }
}

  Widget _buildHorizontalCard() {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(height * 0.6, width),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${property.price.toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showRating && property.rating != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${property.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (property.reviewCount != null) 
                          Text(
                            ' (${property.reviewCount} Reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildImage(220, double.infinity),
              if (showFavorite)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children: [
                    _buildBadge('${property.numberOfBeds} Beds'),
                    const SizedBox(width: 8),
                    _buildBadge('${property.numberOfBathrooms} Bathroom'),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showLocation)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      property.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${property.price.toInt()} /mo',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (showRating && property.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${property.rating}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (property.reviewCount != null) 
                              Text(
                                ' (${property.reviewCount})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double height, double width) {
  if (property.imageUrl.startsWith('assets/')) {
    // Handle local asset images
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Image.asset(
        property.imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      ),
    );
  } else {
    // Handle network images (original implementation)
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: property.imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: height,
            width: width,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      ),
    );
  }
}

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}