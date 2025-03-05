import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routes.dart';
import '../../logic/blocs/properties/properties_bloc.dart';
import '../../logic/blocs/properties/properties_event.dart';
import '../../logic/blocs/properties/properties_state.dart'; // Added import
import '../widgets/category_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/house1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black45,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Homzes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Main Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Find the best',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'place for you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Category Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryButton(
                        title: 'Rent',
                        icon: Icons.chair_outlined,
                        color: const Color(0xFFF9E3CF),
                        onPressed: () {
                          //Add Navigate function
                        },
                      ),
                      CategoryButton(
                        title: 'Buy',
                        icon: Icons.apartment_outlined,
                        color: const Color(0xFFEEF5B1),
                        onPressed: () {
                          //Add Navigate function
                        },
                      ),
                      CategoryButton(
                        title: 'Sell',
                        icon: Icons.home_outlined,
                        color: const Color(0xFFD7F0DE),
                        onPressed: () {
                          //Add Navigate function
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Create Account Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: BlocConsumer<PropertiesBloc, PropertiesState>(
                      listener: (context, state) {
                        // When loading completes, navigate to catalog screen
                        if (state is PropertiesLoaded) {
                          Navigator.pushNamed(context, AppRouter.catalogScreen);
                        } else if (state is PropertiesError) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${state.message}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is PropertiesLoading) {
                          // Show loading indicator while uploading
                          return ElevatedButton(
                            onPressed: null, // Disable button during loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF34C759),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Processing...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        // Regular button when not loading
                        return ElevatedButton(
                          onPressed: () {
                            print("Create account button pressed");
                            
                            // Trigger sample data upload and addition
                            final propertiesBloc = context.read<PropertiesBloc>();
                            propertiesBloc.add(AddSampleProperties());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF34C759),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}