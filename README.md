# 📝 PowerSync Todo App

A modern Flutter Todo application built with Clean Architecture, PowerSync for offline-first synchronization, and Riverpod for state management.

## ✨ Features

- **📱 Offline-First**: Works seamlessly offline with automatic sync when online
- **🔄 Real-time Sync**: Changes sync across devices in real-time using PowerSync
- **🎨 Modern UI**: Beautiful Material Design 3 interface with Google Fonts
- **🔍 Search**: Find todos quickly with real-time search
- **✅ Complete/Incomplete**: Toggle todo completion status
- **📝 Rich Content**: Add titles and descriptions to todos
- **🗑️ Soft Delete**: Safe deletion with undo capability
- **⚡ Fast**: Instant local operations with background sync

## 🏗️ Architecture

This app follows **Clean Architecture** principles with three main layers:

- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management

### Tech Stack

- **Flutter**: Cross-platform mobile development
- **Riverpod**: State management and dependency injection
- **PowerSync**: Offline-first data synchronization
- **SQLite**: Local database storage
- **Clean Architecture**: Scalable and maintainable code structure

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.2.3 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd powersynctodo
   ```

2. **Install dependencies**
   ```bash
   flutter packages get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure PowerSync** (Optional)
   
   Update the PowerSync configuration in `lib/core/constants/app_constants.dart`:
   ```dart
   static const String powerSyncEndpoint = 'wss://your-powersync-endpoint.com';
   static const String powerSyncToken = 'your-powersync-token';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### Creating Todos

1. Tap the **+** button to add a new todo
2. Enter a title (required) and optional description
3. Tap **Save** to create the todo
4. The todo appears immediately in your list

### Managing Todos

- **Complete/Incomplete**: Tap on any todo to toggle its completion status
- **Search**: Use the search bar to find specific todos
- **Delete**: Long press or use the menu to delete todos
- **Edit**: Tap the edit option to modify todo content

### Offline Usage

- All operations work offline
- Changes are saved locally and synced when online
- The sync status indicator shows connection state
- **Green**: Connected and synced
- **Orange**: Syncing in progress
- **Red**: Offline

## 🧪 Testing

Run the test suite:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/todo/domain/entities/todo_test.dart
```

### Test Coverage

The app includes comprehensive unit tests covering:
- Entity business logic
- Use case operations
- Data model serialization
- Repository implementations

Target coverage: 50-60% of critical functionality

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities
│   ├── constants/                  # App constants and database schema
│   ├── errors/                     # Error handling
│   └── network/                    # PowerSync service
├── features/
│   └── todo/                       # Todo feature module
│       ├── data/                   # Data layer
│       │   ├── datasources/        # SQLite data sources
│       │   ├── models/             # Data models
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business operations
│       └── presentation/           # Presentation layer
│           ├── pages/              # Screen widgets
│           ├── providers/          # Riverpod providers
│           └── widgets/            # UI components
└── main.dart                       # App entry point
```

## 🔧 Configuration

### PowerSync Setup

1. **Create a PowerSync account** at [powersync.co](https://powersync.co)
2. **Set up your backend** with PowerSync integration
3. **Configure sync rules** for data access control
4. **Update endpoint and token** in the app constants

### Database Schema

The app uses SQLite with the following schema:

```sql
CREATE TABLE todos (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  completed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  user_id TEXT,
  deleted INTEGER NOT NULL DEFAULT 0
);
```

## 🎨 Customization

### Themes

The app uses Material Design 3 with customizable themes. Update `lib/main.dart` to modify:

- Color scheme
- Typography (Google Fonts)
- Component styles
- App bar appearance

### Fonts

The app uses **Poppins** font family. To change:

1. Update `pubspec.yaml` dependencies
2. Modify theme in `main.dart`
3. Run `flutter packages get`

## 🚀 Deployment

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS

```bash
# Build iOS app
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features
- Follow Clean Architecture principles

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [Riverpod](https://riverpod.dev) - State management
- [PowerSync](https://powersync.co) - Offline-first sync
- [Google Fonts](https://fonts.google.com) - Typography
- [Material Design](https://material.io) - Design system

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/your-repo/issues) page
2. Create a new issue with detailed information
3. Contact the development team

---

**Happy Todo-ing! 🎉**