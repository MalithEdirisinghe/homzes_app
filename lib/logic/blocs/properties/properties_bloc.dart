import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/property_repository.dart';
import 'properties_event.dart';
import 'properties_state.dart';
import '../../../data/models/property.dart';

class PropertiesBloc extends Bloc<PropertiesEvent, PropertiesState> {
  final PropertyRepository _propertyRepository;
  StreamSubscription? _featuredPropertiesSubscription;
  StreamSubscription? _newOfferPropertiesSubscription;
  StreamSubscription? _popularRentPropertiesSubscription;
  StreamSubscription? _allPropertiesSubscription;

  PropertiesBloc(this._propertyRepository) : super(PropertiesInitial()) {
    on<LoadFeaturedProperties>(_onLoadFeaturedProperties);
    on<LoadNewOfferProperties>(_onLoadNewOfferProperties);
    on<LoadPopularRentProperties>(_onLoadPopularRentProperties);
    on<LoadAllProperties>(_onLoadAllProperties);
    on<AddSampleProperties>(_onAddSampleProperties);
  }

  // Improved state handling that preserves existing data
  void _onLoadNewOfferProperties(
  LoadNewOfferProperties event,
  Emitter<PropertiesState> emit,
) async {
  try {
    print("Loading new offer properties from Firebase...");
    
    // Only emit loading state if we're starting from initial
    if (state is PropertiesInitial) {
      emit(PropertiesLoading());
    }
    
    await _newOfferPropertiesSubscription?.cancel();
    _newOfferPropertiesSubscription = _propertyRepository.getNewOfferProperties().listen(
      (properties) {
        print("Received new offer properties: ${properties.length}");
        if (properties.isNotEmpty) {
          print("First new offer property: ${properties[0].title}");
        }
        
        final currentState = state;
        if (currentState is PropertiesLoaded) {
          emit(currentState.copyWith(newOfferProperties: properties));
          print("Updated state with new offer properties, total: ${properties.length}");
        } else {
          emit(PropertiesLoaded(newOfferProperties: properties));
          print("Created new loaded state with new offer properties");
        }
      },
      onError: (error) {
        print("Error loading new offer properties: $error");
        emit(PropertiesError(error.toString()));
      }
    );
  } catch (e) {
    print("Exception in _onLoadNewOfferProperties: $e");
    emit(PropertiesError(e.toString()));
  }
}

void _onLoadPopularRentProperties(
  LoadPopularRentProperties event,
  Emitter<PropertiesState> emit,
) async {
  try {
    print("Loading popular rent properties from Firebase...");
    
    if (state is PropertiesInitial) {
      emit(PropertiesLoading());
    }
    
    await _popularRentPropertiesSubscription?.cancel();
    _popularRentPropertiesSubscription = _propertyRepository.getPopularRentProperties().listen(
      (properties) {
        print("Received popular rent properties: ${properties.length}");
        if (properties.isNotEmpty) {
          print("First popular rent property: ${properties[0].title}");
        }
        
        final currentState = state;
        if (currentState is PropertiesLoaded) {
          emit(currentState.copyWith(popularRentProperties: properties));
          print("Updated state with popular rent properties");
        } else {
          emit(PropertiesLoaded(popularRentProperties: properties));
          print("Created new loaded state with popular rent properties");
        }
      },
      onError: (error) {
        print("Error loading popular rent properties: $error");
        emit(PropertiesError(error.toString()));
      }
    );
  } catch (e) {
    print("Exception in _onLoadPopularRentProperties: $e");
    emit(PropertiesError(e.toString()));
  }
}

void _onLoadAllProperties(
  LoadAllProperties event,
  Emitter<PropertiesState> emit,
) async {
  try {
    print("Loading all properties from Firebase...");
    
    if (state is PropertiesInitial) {
      emit(PropertiesLoading());
    }
    
    await _allPropertiesSubscription?.cancel();
    _allPropertiesSubscription = _propertyRepository.getAllProperties().listen(
      (properties) {
        print("Received all properties: ${properties.length}");
        if (properties.isNotEmpty) {
          print("First property from all: ${properties[0].title}");
        }
        
        final currentState = state;
        if (currentState is PropertiesLoaded) {
          emit(currentState.copyWith(allProperties: properties));
          print("Updated state with all properties");
        } else {
          emit(PropertiesLoaded(allProperties: properties));
          print("Created new loaded state with all properties");
        }
      },
      onError: (error) {
        print("Error loading all properties: $error");
        emit(PropertiesError(error.toString()));
      }
    );
  } catch (e) {
    print("Exception in _onLoadAllProperties: $e");
    emit(PropertiesError(e.toString()));
  }
}
void _onLoadFeaturedProperties(
  LoadFeaturedProperties event,
  Emitter<PropertiesState> emit,
) async {
  try {
    print("Loading featured properties from Firebase...");
    
    // Only emit loading state if we're starting from initial
    if (state is PropertiesInitial) {
      emit(PropertiesLoading());
    }
    
    await _featuredPropertiesSubscription?.cancel();
    _featuredPropertiesSubscription = _propertyRepository.getFeaturedProperties().listen(
      (properties) {
        print("Received featured properties: ${properties.length}");
        if (properties.isNotEmpty) {
          print("First featured property: ${properties[0].title}");
        }
        
        final currentState = state;
        if (currentState is PropertiesLoaded) {
          emit(currentState.copyWith(featuredProperties: properties));
          print("Updated state with featured properties, total: ${properties.length}");
        } else {
          emit(PropertiesLoaded(featuredProperties: properties));
          print("Created new loaded state with featured properties");
        }
      },
      onError: (error) {
        print("Error loading featured properties: $error");
        emit(PropertiesError(error.toString()));
      }
    );
  } catch (e) {
    print("Exception in _onLoadFeaturedProperties: $e");
    emit(PropertiesError(e.toString()));
  }
}

  // Apply similar changes to _onLoadNewOfferProperties and _onLoadPopularRentProperties
  
  void _onAddSampleProperties(
    AddSampleProperties event,
    Emitter<PropertiesState> emit,
  ) async {
    try {
      print("Adding sample properties to Firebase...");
      emit(PropertiesLoading());
      
      await _propertyRepository.addSampleData();
      print("Sample data added successfully to Firebase");
      
      // Wait a moment before loading data to ensure Firebase has processed the writes
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load all data types in sequence to avoid race conditions
      await _loadAllPropertyTypes(emit);
      
    } catch (e) {
      print("Error adding sample properties: $e");
      emit(PropertiesError(e.toString()));
    }
  }
  
  // New helper method to load all property types in sequence
  Future<void> _loadAllPropertyTypes(Emitter<PropertiesState> emit) async {
    try {
      final featuredProperties = await _propertyRepository.getFeaturedProperties().first;
      final newOfferProperties = await _propertyRepository.getNewOfferProperties().first;
      final popularRentProperties = await _propertyRepository.getPopularRentProperties().first;
      
      emit(PropertiesLoaded(
        featuredProperties: featuredProperties,
        newOfferProperties: newOfferProperties,
        popularRentProperties: popularRentProperties,
      ));
      print("Loaded ALL property types at once - Featured: ${featuredProperties.length}, New: ${newOfferProperties.length}, Popular: ${popularRentProperties.length}");
    } catch (e) {
      print("Error in _loadAllPropertyTypes: $e");
      emit(PropertiesError(e.toString()));
    }
  }
}