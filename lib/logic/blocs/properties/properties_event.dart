import 'package:equatable/equatable.dart';

abstract class PropertiesEvent extends Equatable {
  const PropertiesEvent();

  @override
  List<Object> get props => [];
}

class LoadFeaturedProperties extends PropertiesEvent {}

class LoadNewOfferProperties extends PropertiesEvent {}

class LoadPopularRentProperties extends PropertiesEvent {}

class LoadAllProperties extends PropertiesEvent {}

class AddSampleProperties extends PropertiesEvent {}