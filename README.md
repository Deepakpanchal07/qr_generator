# 📱 QR Studio – QR Code Generator App

QR Studio is a Flutter-based QR code generator application that allows users to generate QR codes and save them to their device gallery. The app features a clean interface with a modern dark purple theme.

[Github repository link](https://github.com/Deepakpanchal07/qr_generator)

## 📸 Screenshots

### 🔳 QR Code Generation
<img width="449" height="314" alt="Screenshot 2026-10-26 144317" src="https://github.com/user-attachments/assets/68b6febc-1bb5-401b-ad17-88e51ffbdbaf" />


### 💾 Save QR Code
<img width="447" height="411" alt="Screenshot 2026-10-26 144334" src="https://github.com/user-attachments/assets/9afa197c-8d66-4c2c-a3aa-655823a37f13" />


> Add your actual screenshots to the `screenshots/` folder and update the filenames if necessary.

## ✨ Features

- 🔳 Generate QR codes
- 📝 Create QR codes from user-provided text
- 💾 Save generated QR code images to the device gallery
- 🎨 Dark purple themed user interface
- 📱 Built with Flutter for Android
- ⚡ Simple and user-friendly experience

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | UI development |
| Dart | Application logic |
| `qr_flutter` | QR code generation and rendering |
| `image_gallery_saver_plus` | Saving images to the device gallery |
| Android Studio | Development and testing |
| Git & GitHub | Version control |

## 📁 Project Structure

```text
qr generator/
├── android/
├── lib/
├── assets/
├── test/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

*Note: Update the structure to match the actual files and folders in your project.*

## ⚙️ Prerequisites

Before running the project, install:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android emulator or a compatible Android device
- Git

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate into the cloned project directory:

```bash
cd "qr generator"
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with your actual repository URL.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Application

Connect an Android device or start an emulator, then run:

```bash
flutter run
```

### 4. Build an APK

To generate a release APK:

```bash
flutter build apk --release
```

The APK will be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 📦 Dependencies

The project uses the following Flutter packages:

- [`qr_flutter`](https://pub.dev/packages/qr_flutter) — QR code generation and rendering.
- [`image_gallery_saver_plus`](https://pub.dev/packages/image_gallery_saver_plus) — Saving generated images to the device gallery.

## 🔮 Future Improvements

- QR code history
- QR code scanning
- Share generated QR codes
- Customize QR code colors and styles
- Generate QR codes for URLs, contact details, and Wi-Fi credentials

## 👨‍💻 Developer

**Deepak Panchal**

B.Tech in Computer Science and Engineering

- LinkedIn: [Deepak Panchal](https://www.linkedin.com/in/deepak-panchal-a0aa41362/)

## 📄 License

This project is available for learning and portfolio purposes. Add an appropriate open-source license if you plan to distribute it publicly.
