# identify_attendance_app

This is an attendance taking application that utilizes the use of face biometrics and QR code for tracking attendance using flutter/dart. The application includes essential features such as authentication and attendance tracking by face capturing or scanning of QR codes with a visually appealing UI ensuring a seamless user-friendly experience. 


## Features
Authentication: User sign-up, login, and secure session management.
Attendance tracking: Allows attendance taking by face capturing or QR code scanning.

## Prerequisites
- [FlutterSDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio](https://visualstudio.microsoft.com/) with Flutter and Dart plugins

## Dependencies
This application uses the following dependencies to provide essential functionalities and ensure a smooth development experience:


### Core Dependencies
1. Cupertino_icons: ^1.0.6
Provides a set of iOS-style icons to be used in the application.

2. Provider: ^6.1.2
A state management solution that allows you to handle state and dependency injection in a structured and easy-to-use manner.

3. Firebase_core: ^2.24.2
An advanced state management library that is an improvement over the original Provider package, offering better performance and flexibility.

### UI and Styling
4. Google_fonts: ^6.2.1
Allows you to easily use any of the fonts from fonts.google.com in your Flutter app.

5. modal_progress_hud_nsn: ^0.5.1
A utility for displaying a modal progress view

6. qr_flutter: ^4.1.0
Allows QR code rendering via a Widget or custom painter.

7. qr_code_scanner: ^1.0.1
Allows scanning of QR code with device camera.

8. geolocator: ^11.1.0
Gets the location of the device in longitude and latitude

9. csv: ^6.0.0
Allows downloading of files in csv format

### Networking and APIs
10. tflite_flutter: ^0.10.4
A package that provides an easy, flexible, and fast Dart API to integrate TFLite models in flutter apps.

### Firebase Integration
11. Firebase_auth ^4.16.0
Provides Firebase authentication services, enabling user sign-up, login, and session management.

12. Firebase_core: ^2.24.2
A required dependency for connecting your Flutter application with Firebase.

13. cloud_firestore: ^4.14.0
Provides the database for storing necessary information in form of collections

### Utility Packages
14. google_mlkit_face_detection: ^0.9.0
Allows detection of faces in an image, identify key facial features, and get the contours of detected faces.

15. google_mlkit_commons: ^0.6.1
Implements google's standalone ml kit made for mobile platform.

16. path_provider: ^2.1.1
For getting commonly used locations on host platform file systems, such as the temp and app data directories.

### Image Handling
17. camera: ^0.10.5+9:
Enables image and video picking from the device’s camera.

18. image: ^4.1.3
Enables the ability to load, manipulate, and save images with various image file formats.


## Getting Started
### 1. Clone the Repository
bash
```Copy code
https://github.com/SSID98/identify_attendance_app.git
```


### 2. Install Dependencies
Run the following command to install the necessary packages:
bash
```Copy code
flutter pub get
```

### 3. Configure Environment
Create a .env file in the root directory and add your environment variables:
bash
```Copy code
API_BASE_URL=
AUTH_API_KEY=
```

### 4. Run the Application
To start the application on an emulator or a connected device, run:
bash
```Copy code
flutter run
```

### 5. Building for Release
For Android:
bash
```Copy code
flutter build apk --release
```

For iOS:
```bash

flutter build ios --release
```      







