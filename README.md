# Nook & Corner App

Nook & Corner App is a Flutter application that provides functionality [describe app briefly]. This README
outlines the setup and running instructions for the project.

## Prerequisites

- Git
- Flutter
- Flutter Version Management (FVM)
- FlutterFire CLI
- Android Studio or VS Code
- Setup Make Gen :  Makefile

## Getting Started

### Clone the Project

First, clone the project from the Git repository:

```bash
git clone https://github.com/<path_here>.git
cd NookCornerApp<folder_name>
```

### Manually Configuring the Project Locally

1. **Install FVM**

   ```bash
   pub global activate fvm
   ```

2. **Setup FVM with the Flutter Version from `pubspec.yaml`**

   Navigate to the root of the project and run:

   ```bash
   fvm install
   
   dart pub global activate fvm && fvm install $(version) && fvm use $(version) && fvm flutter doctor
   
   ```

3. **Install and Run the FlutterFire CLI**

   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   
   dart pub global activate flutterfire_cli && flutterfire configure

   ```


# Enjoys! 🚀