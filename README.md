# Homzes Mobile Application

## Overview

Homzes is a cross-platform real estate application built with Flutter and Firebase. The application allows users to browse, search, and view property listings with detailed information. The app features a modern UI design based on Figma specifications with smooth navigation and interactive elements.

## Technologies and Libraries

### Core Technologies
- **Flutter**: UI toolkit for building natively compiled applications
- **Firebase**: Backend services including authentication, database, and storage
- **BLoC Pattern**: State management solution for separating business logic from UI

### Firebase Services
- **Cloud Firestore**: NoSQL database for storing property listings and user data
- **Firebase Authentication**: User authentication and account management
- **Firebase Storage**: Cloud storage for property images and media files

### Key Libraries
- `flutter_bloc`: Implementation of the BLoC pattern for state management
- `equatable`: Simplifies equality comparisons for BLoC states and events
- `cloud_firestore`: Firestore database integration
- `firebase_auth`: Firebase authentication services
- `firebase_storage`: Firebase cloud storage integration
- `path_provider`: File system path access for local storage
- `sqflite`: SQLite database support for local data caching
- `url_launcher`: URL handling for external links

## Project Structure

```
lib/
├─ app.dart
├─ data/
│  ├─ models/
│  │  └─ property.dart
│  ├─ repositories/
│  │  └─ property_repository.dart
│  └─ services/
│     ├─ firebase_service.dart
│     └─ image_service.dart
├─ firebase_options.dart
├─ logic/
│  └─ blocs/
│     └─ properties/
│        ├─ properties_bloc.dart
│        ├─ properties_event.dart
│        └─ properties_state.dart
├─ main.dart
├─ presentation/
│  ├─ screens/
│  │  ├─ catalog_screen.dart
│  │  ├─ popular_screen.dart
│  │  └─ welcome_screen.dart
│  └─ widgets/
│     ├─ category_button.dart
│     ├─ property_card.dart
│     └─ search_bar.dart
└─ routes.dart
```

## Setup and Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for native development)
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone 
   cd homzes_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)
   - Add Android and/or iOS apps to your Firebase project
   - Download the configuration files:
     - For Android: `google-services.json` (place in `android/app/`)
     - For iOS: `GoogleService-Info.plist` (place in `ios/Runner/`)
   - Enable Authentication, Firestore, and Storage in the Firebase console

4. **Run the application**
   ```bash
   flutter run
   ```

## Firebase Configuration

### Database Structure
The application uses the following Firestore collection:
- `properties`: Stores property listings with fields:
  - `title`: Property title
  - `image`: Image URL
  - `location`: Property location
  - `price`: Property price
  - `numberOfBeds`: Number of bedrooms
  - `numberOfBathrooms`: Number of bathrooms
  - `isFeatured`: Featured property flag
  - `isNewOffer`: New offer flag
  - `rating`: Property rating (optional)
  - `reviewCount`: Number of reviews (optional)

### Storage Structure
- Property images should be uploaded to Firebase Storage in the `property_images` folder

## Implementing for Additional Devices

### Web Implementation
1. Enable web support in your Flutter project:
   ```bash
   flutter config --enable-web
   ```
2. Run the app for web:
   ```bash
   flutter run -d chrome
   ```

### Desktop Implementation (Windows, macOS, Linux)

1. Enable desktop support for your target platform:
   ```bash
   # For Windows
   flutter config --enable-windows-desktop
   
   # For macOS
   flutter config --enable-macos-desktop
   
   # For Linux
   flutter config --enable-linux-desktop
   ```

2. Update platform-specific code:
   - Check platform-specific implementations in the `windows`, `macos`, or `linux` directories
   - Ensure proper native plugins are available for your target platform

3. Run the app for desktop:
   ```bash
   # For Windows
   flutter run -d windows
   
   # For macOS
   flutter run -d macos
   
   # For Linux
   flutter run -d linux
   ```

### Configuration for Different Screen Sizes

The application uses responsive design to adapt to different screen sizes. Key considerations:

1. **MediaQuery**: Use `MediaQuery.of(context).size` to access screen dimensions
2. **LayoutBuilder**: Implement adaptive layouts with `LayoutBuilder`
3. **Flexible and Expanded widgets**: Create flexible UI elements that adapt to screen size
4. **Testing**: Test the application on different devices and screen sizes

## Development Workflow

### State Management with BLoC

The application uses the BLoC pattern for state management:

1. **Events**: Actions that trigger state changes (located in `*_event.dart` files)
2. **States**: Immutable states representing the UI state (located in `*_state.dart` files)
3. **BLoCs**: Business logic components that convert events to states (located in `*_bloc.dart` files)

### Adding a New Feature

1. Define the data model in `lib/data/models/`
2. Implement repository methods in `lib/data/repositories/`
3. Create BLoC components (events, states, and BLoC class)
4. Implement UI components in `lib/presentation/`
5. Update routes if necessary

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)