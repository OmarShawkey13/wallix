# Wallix 📱

A premium, modern, and high-performance Wallpaper application built with Flutter. Wallix offers a curated collection of stunning wallpapers with advanced editing tools and a seamless user experience.

## 🚀 Key Features

-   **Infinite Discovery**: Browse thousands of wallpapers with smooth pagination and infinite scrolling.
-   **Smart Categorization**: Find the perfect wallpaper through well-organized categories.
-   **Advanced Image Editor (Crop & Adjust)**:
    -   **Interactive Cropping**: Precise framing with pinch-to-zoom and drag-to-move.
    -   **Dynamic Filters**: Adjust **Blur** and **Brightness** in real-time.
    -   **Live Simulation**: Preview how your wallpaper looks with a mock Home/Lock screen UI.
-   **Favorites Library**: Save and manage your favorite wallpapers locally using a secure SQLite database.
-   **One-Tap Application**: Set wallpapers for Home Screen, Lock Screen, or both instantly.
-   **High-Quality Downloads**: Save wallpapers directly to your gallery with automatic media scanning.
-   **Multi-Language Support**: Fully localized in **English** and **Arabic**.
-   **Dark Mode**: Immersive Material 3 Dark theme support.

## ✨ UI/UX Highlights

-   **Material 3 Ready**: Built using the latest Material Design components and principles.
-   **Glassmorphism Design**: Elegant blurred overlays and frosted glass effects for a sophisticated look.
-   **Smooth Animations**: Immersive Hero transitions and micro-interactions for a fluid feel.
-   **Responsive Layout**: Optimized for various screen sizes and aspect ratios.

## 🛠 Tech Stack & Libraries

-   **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc) (Cubit pattern) for clean and predictable state.
-   **Dependency Injection**: [Get_it](https://pub.dev/packages/get_it) for decoupled service management.
-   **Networking**: [Dio](https://pub.dev/packages/dio) with functional error handling using [Dartz](https://pub.dev/packages/dartz).
-   **Database**: [Sqflite](https://pub.dev/packages/sqflite) for local persistence.
-   **Image Caching**: [Cached_network_image](https://pub.dev/packages/cached_network_image) for fast and efficient loading.
-   **UI Enhancements**: [Skeletonizer](https://pub.dev/packages/skeletonizer) for modern loading states.

## 🏗 Architecture

Wallix follows a **Feature-Driven Layered Architecture**, ensuring the code is maintainable, testable, and scalable.

### 📂 Detailed Project Structure

```
lib/
├── core/
│   ├── di/                # Dependency Injection (Service Locator)
│   ├── models/            # Shared Data Entities
│   ├── network/           # API (Remote) & Database (Local) logic
│   ├── theme/             # Design System (Material 3 Colors & Typography)
│   └── utils/             # Constants, Cubits, Spacing & Context Extensions
├── features/
│   ├── home/              # Wallpaper Discovery, Categories & Favorites
│   │   └── presentation/
│   │       ├── screen/    # Feature Entry Points
│   │       └── widgets/   # Reusable Feature UI Components
│   └── wallpaper_preview/ # Advanced Preview, Editing & Application
│       └── presentation/
│           ├── screen/    # Full-screen Preview & Crop/Edit Screens
│           └── widgets/   # Adjustment panels, Action bars & Mock UI
└── main.dart              # Global Providers & App Configuration
```

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (3.11.1 or higher)
- Android Studio / VS Code

### Installation
1.  **Clone the Repo**:
    ```bash
    git clone https://github.com/OmarShawkey13/wallix.git
    ```
2.  **Get Packages**:
    ```bash
    flutter pub get
    ```
3.  **Run Application**:
    ```bash
    flutter run
    ```

## 🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.

---
Developed with passion by **Omar Shawkey** 💙
