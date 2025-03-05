import 'package:equatable/equatable.dart';
import '../../../data/models/property.dart';

abstract class PropertiesState extends Equatable {
  const PropertiesState();
  
  @override
  List<Object?> get props => [];
}

class PropertiesInitial extends PropertiesState {}

class PropertiesLoading extends PropertiesState {}

class PropertiesLoaded extends PropertiesState {
  final List<Property> featuredProperties;
  final List<Property> newOfferProperties;
  final List<Property> popularRentProperties;
  final List<Property> allProperties;

  const PropertiesLoaded({
    this.featuredProperties = const [],
    this.newOfferProperties = const [],
    this.popularRentProperties = const [],
    this.allProperties = const [],
  });
  
  PropertiesLoaded copyWith({
    List<Property>? featuredProperties,
    List<Property>? newOfferProperties,
    List<Property>? popularRentProperties,
    List<Property>? allProperties,
  }) {
    return PropertiesLoaded(
      featuredProperties: featuredProperties ?? this.featuredProperties,
      newOfferProperties: newOfferProperties ?? this.newOfferProperties,
      popularRentProperties: popularRentProperties ?? this.popularRentProperties,
      allProperties: allProperties ?? this.allProperties,
    );
  }

  @override
  List<Object?> get props => [featuredProperties, newOfferProperties, popularRentProperties,allProperties];
}

class PropertiesError extends PropertiesState {
  final String message;

  const PropertiesError(this.message);
  
  @override
  List<Object> get props => [message];
}