# Todo List App 

A clean and efficient Todo List application built with Flutter to help you manage your daily tasks effectively. This project demonstrates the use of Flutter widgets, state management, and responsive design.

## Download

Try out the app on your Android device:

**Download APK** : https://drive.google.com/file/d/1Aqt_7y_5Ya5kaEzNdai_92KwexCcsu3q/view?usp=sharing

## Features

- **Add Tasks**: Easily add new tasks to your list.
- **Mark as Done**: Check off tasks as you complete them.
- **Delete Tasks**: Remove tasks you no longer need.
- **Responsive UI**: Clean interface that works well on different screen sizes.

## Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/fd52d7d5-2fcb-43eb-a3be-982cfc25a2fb" width="200" />
  <img src="https://github.com/user-attachments/assets/0bb2a51a-7a9b-48a0-a4b7-8974276643a0" width="200" />
  <img src="https://github.com/user-attachments/assets/81efdd92-6f1a-4ee8-9897-027394fe1667" width="200" />
  <img src="https://github.com/user-attachments/assets/e3f94701-3498-40bb-a410-383d33c2f05d" width="200" />
</div>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/c33019f1-d2bf-40c1-9e89-8e744f33aa6c" width="200" />
  <img src="https://github.com/user-attachments/assets/d09d795d-296b-44c1-b17f-0f5885773193" width="200" />
  <img src="https://github.com/user-attachments/assets/e77ac702-2cb9-4369-8e50-279e928fdaed" width="200" />
  <img src="https://github.com/user-attachments/assets/aca14e33-37ba-4561-b88d-65aa50766861" width="200" />
</div>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/8bb376a4-3c87-4adc-86a2-edb61aa3a863" width="200" />
  <img src="https://github.com/user-attachments/assets/3cee28fc-c41b-4765-96cc-75d8fada8a3b" width="200" />
  <img src="https://github.com/user-attachments/assets/309d3b06-6691-4927-bedb-8db8f51c9f14" width="200" />
  <img src="https://github.com/user-attachments/assets/d0821e7e-ec81-4f0b-8100-949859cb1a3d" width="200" />
</div>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/9781ba11-bc2d-40b4-b274-c2dc1143f99a" width="200" />
  <img src="https://github.com/user-attachments/assets/f9c33529-18bd-44c2-9d7e-7f93100b7bfb" width="200" />
  <img src="https://github.com/user-attachments/assets/9637b865-824b-4d66-904e-113aac7deaa2" width="200" />
</div>

## Project Structure

```text
lib/
│
├── main.dart
├── models/
├── screens/
├── widgets/
├── services/
├── utils/
└── constants/

assets/
├── images/
└── fonts/
```

## Widget Tree

Here is a high-level overview of the widget structure used in this application:

```text
MyApp
 └── MaterialApp
      └── Home (StatefulWidget)
           └── Scaffold
                ├── AppBar
                │    └── Text('Todo List')
                ├── Body
                │    └── Column
                │         ├── SearchBox (Container)
                │         └── Expanded
                │              └── ListView
                │                   └── ToDoItem (ListTile/Card)
                └── FloatingActionButton
                     └── Icon(add)
```

---

## Tech Stack

| Technology | Description |
|------------|-------------|
| Flutter | Cross-platform UI Toolkit |
| Dart | Programming Language |
| Material Design | UI Components |
| Android | Deployment Platform |

---

## Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK
- Android Studio or VS Code
- Android Emulator or Physical Device

---

## Installation

Clone the repository.

```bash
git clone https://github.com/ajinkya-85/Flutter-Todo-list.git
```

Navigate into the project.

```bash
cd Flutter-Todo-list
```

Install dependencies.

```bash
flutter pub get
```

Run the application.

```bash
flutter run
```

---

## Folder Overview

| Folder | Purpose |
|---------|----------|
| lib/ | Application source code |
| assets/ | Images, fonts and other assets |
| android/ | Android-specific configuration |
| ios/ | iOS-specific configuration |
| web/ | Web configuration |
| test/ | Unit and widget tests |

---

## Application Flow

```text
Launch App
      │
      ▼
View Todo List
      │
      ├────────────┐
      ▼            ▼
 Add Task      Select Task
      │            │
      ▼            ▼
 Save Task    Edit/Delete/Complete
      │            │
      └────────────┘
             │
             ▼
 Updated Todo List
```

## Author

**Ajinkya Ghode**

GitHub: https://github.com/ajinkya-85

---

## Support

If you found this project helpful, consider giving it a ⭐ on GitHub.

It motivates further development and helps others discover the project.

---

<div align="center">

Made with 🖤 using Flutter

</div>

