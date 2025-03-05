import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routes.dart';
import '../../logic/blocs/properties/properties_bloc.dart';
import '../../logic/blocs/properties/properties_state.dart';
import '../../logic/blocs/properties/properties_event.dart';
import '../widgets/search_bar.dart';
import '../widgets/property_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger data loading when screen is built - this ensures we load data
    // even if the BLoC is already initialized but didn't load data automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("CatalogScreen: Triggering initial data load");
      final bloc = context.read<PropertiesBloc>();
      bloc.add(LoadFeaturedProperties());
      bloc.add(LoadNewOfferProperties());
      bloc.add(LoadPopularRentProperties());
      context.read<PropertiesBloc>().add(LoadAllProperties());
    });
    
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5B1),
      body: SafeArea(
        child: BlocBuilder<PropertiesBloc, PropertiesState>(
          builder: (context, state) {
            print("CatalogScreen: Current BLoC state: ${state.runtimeType}");
            
            if (state is PropertiesInitial) {
              print("CatalogScreen: PropertiesInitial state - dispatching load events");
              context.read<PropertiesBloc>().add(LoadFeaturedProperties());
              context.read<PropertiesBloc>().add(LoadNewOfferProperties());
              context.read<PropertiesBloc>().add(LoadPopularRentProperties());
              return const Center(child: CircularProgressIndicator());
            } 
            else if (state is PropertiesLoading) {
              print("CatalogScreen: PropertiesLoading state - showing progress indicator");
              return const Center(child: CircularProgressIndicator());
            } 
            else if (state is PropertiesError) {
              print("CatalogScreen: PropertiesError state - ${state.message}");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.message}"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        print("CatalogScreen: Retry button pressed - reloading data");
                        context.read<PropertiesBloc>().add(LoadFeaturedProperties());
                        context.read<PropertiesBloc>().add(LoadNewOfferProperties());
                        context.read<PropertiesBloc>().add(LoadPopularRentProperties());
                        context.read<PropertiesBloc>().add(LoadAllProperties());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } 
            else if (state is PropertiesLoaded) {
              print("CatalogScreen: PropertiesLoaded state");
              print("Featured properties: ${state.featuredProperties.length}");
              print("New offer properties: ${state.newOfferProperties.length}");
              print("Popular rent properties: ${state.popularRentProperties?.length ?? 'null'}");
              
              return Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Open drawer or menu
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              'Hi, Stanislav',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  const CustomSearchBar(),
                  
                  const SizedBox(height: 24),
                  
                  // Content
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Featured Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Featured',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRouter.popularScreen);
                                    },
                                    child: const Text(
                                      'View all',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Featured Properties List
                            state.featuredProperties.isEmpty 
                              ? _buildEmptySection('No featured properties available')
                              : SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(left: 20, right: 8),
                                    itemCount: state.featuredProperties.length,
                                    itemBuilder: (context, index) {
                                      final property = state.featuredProperties[index];
                                      print("Rendering featured property: ${property.title}");
                                      return PropertyCard(
                                        property: property,
                                        isFeatured: true,
                                      );
                                    },
                                  ),
                                ),
                            
                            const SizedBox(height: 24),
                            
                            // New Offers Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'New offers',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRouter.popularScreen);
                                    },
                                    child: const Text(
                                      'View all',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // New Offers List
                            state.newOfferProperties.isEmpty
                              ? _buildEmptySection('No new offers available')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: state.newOfferProperties.length,
                                  itemBuilder: (context, index) {
                                    final property = state.newOfferProperties[index];
                                    print("Rendering new offer property: ${property.title}");
                                    return PropertyCard(
                                      property: property,
                                      isHorizontal: false,
                                    );
                                  },
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            
            // Fallback for unknown state
            print("CatalogScreen: Unknown state: ${state.runtimeType}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Something went wrong"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print("CatalogScreen: Reload button pressed on unknown state");
                      context.read<PropertiesBloc>().add(LoadFeaturedProperties());
                      context.read<PropertiesBloc>().add(LoadNewOfferProperties());
                      context.read<PropertiesBloc>().add(LoadPopularRentProperties());
                    },
                    child: const Text("Reload"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Helper method to create empty state display
  Widget _buildEmptySection(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}