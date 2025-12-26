# Wallix 📱

A beautiful and functional Wallpaper application built with Flutter, designed to provide users with a vast collection of high-quality wallpapers. The app features a modern UI, categorization, offline favorites, and complete customization support.

## 🚀 Features

-   **Browse Wallpapers**: Explore a vast collection of wallpapers with infinite scrolling and pagination.
-   **Categories**: Browse wallpapers by specific categories.
-   **Favorites System**: Save your favorite wallpapers locally to access them later (powered by SQLite).
-   **Theme Customization**: Fully supported Light and Dark modes.
-   **Localization**: Multi-language support (English & Arabic).
-   **Preview**: View wallpapers in full-screen mode before setting them.
-   **Set Wallpaper**: Set wallpapers for Home Screen, Lock Screen, or Both.
-   **Download**: Download wallpapers to your device storage with MediaScanner integration.
-   **Efficient Networking**: optimized API calls using Dio with error handling.

## 🛠 Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.10.4)
-   **Language**: [Dart](https://dart.dev/)
-   **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit pattern)
-   **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
-   **Networking**: [dio](https://pub.dev/packages/dio)
-   **Local Database**: [sqflite](https://pub.dev/packages/sqflite)
-   **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
-   **Utilities**:
    -   [dartz](https://pub.dev/packages/dartz) for functional error handling.
    -   [skeletonizer](https://pub.dev/packages/skeletonizer) for loading states.
    -   [path_provider](https://pub.dev/packages/path_provider) for filesystem access.
    -   [permission_handler](https://pub.dev/packages/permission_handler) for managing permissions.
    -   [media_scanner](https://pub.dev/packages/media_scanner) for updating gallery.
    -   [flutter_wallpaper](https://pub.dev/packages/flutter_wallpaper) for setting wallpapers.

## 🏗 Architecture

The project adopts a **Layered Architecture** focusing on separation of concerns and scalability.

### 📂 Folder Structure

```
lib/
├── core/                  # Shared resources and core logic
│   ├── di/                # Dependency Injection (Service Locator)
│   ├── models/            # Data models (Wallpaper, Category, Translation)
│   ├── network/           # Data Source Layer
│   │   ├── local/         # Local storage (SqfliteHelper, CacheHelper)
│   │   └── remote/        # Remote API (DioHelper, Endpoints)
│   ├── theme/             # App Theme styling (Dark/Light)
│   └── utils/             # Constants, Cubits (Global logic), Routes
├── features/              # Feature-based modules
│   ├── home/              # Main dashboard (Wallpapers, Categories, Favorites, Settings)
│   └── wallpaper_preview/ # Full-screen wallpaper viewer
└── main.dart              # Application entry point & initialization
```

### Key Architectural Highlights

*   **State Management**: The app uses `HomeCubit` to manage global states including wallpaper data fetching, pagination logic (`_loadNextPage`), favorite toggling, theme/language switching, and setting wallpapers.
*   **Dependency Injection**: `GetIt` is used to register and inject dependencies like `Dio`, `SharedPreferences`, and Cubits, ensuring testability and modularity.
*   **Data Layer**:
    *   **Remote**: `DioHelper` manages HTTP requests to the GitHub-hosted JSON APIs.
    *   **Local**: `SqfliteHelper` handles persistent storage for favorite wallpapers, while `CacheHelper` manages user preferences (Theme/Language).

## 🏁 Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/OmarShawkey13/wallix.git
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
Developed with Flutter 💙
