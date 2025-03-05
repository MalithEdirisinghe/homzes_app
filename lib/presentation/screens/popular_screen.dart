import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/properties/properties_bloc.dart';
import '../../logic/blocs/properties/properties_state.dart';
import '../widgets/search_bar.dart';
import '../widgets/property_card.dart';

class PopularScreen extends StatelessWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7F0DE),
      body: SafeArea(
        child: BlocBuilder<PropertiesBloc, PropertiesState>(
          builder: (context, state) {
            if (state is PropertiesLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Menu Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Open drawer or menu
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const CustomSearchBar(),
                  
                  const SizedBox(height: 32),
                  
                  // Popular Rent Offers Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Popular rent offers',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Popular Rent Offers List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.popularRentProperties.length,
                      itemBuilder: (context, index) {
                        final property = state.popularRentProperties[index];
                        return PropertyCard(
                          property: property,
                          isHorizontal: false,
                          showRating: true,
                          showLocation: true,
                          showFavorite: true,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            
            // Loading or Error State
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}