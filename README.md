# Personal Task Manager

A feature-rich cross-platform mobile application built with Flutter that helps users manage their daily tasks effectively. The app provides task organization, reminders, and synchronization across devices using Firebase.

## Features

- **User Authentication**
  - Secure login and registration powered by Firebase Authentication
  - Email and password authentication

- **Task Management**
  - Create, edit, and delete tasks
  - Set task priorities (Low, Medium, High)
  - Add detailed descriptions and due dates
  - Mark tasks as complete

- **Organization**
  - Categorize tasks (Work, Personal, Shopping, etc.)
  - Search functionality
  - Filter tasks by category, due date, or priority

- **Smart Features**
  - Local notifications for task reminders
  - Offline support with local caching
  - Dark/Light mode toggle

## Technologies Used

- Flutter
- Firebase Authentication
- Firebase Firestore
- shared_preferences for local storage
- flutter_local_notifications

## Getting Started

### Prerequisites

- Flutter (latest version)
- Firebase account
- Android Studio / VS Code

### Installation

1. Clone the repository
    git clone https://github.com/yourusername/personal-task-manager.git

2. Install dependencies
    flutter pub get

3. Configure Firebase
   - Create a new Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files
   - Enable Authentication and Firestore in Firebase Console

4. Run the app
    flutter run

