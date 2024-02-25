# Bridge Flutter

## Execution Instructions

This guide will help you run this project on your local environment. Follow the instructions below.

### Prerequisites

Before running the project, make sure you have the following:

- Flutter environment set up on your machine. For Flutter installation, refer to the [official Flutter documentation](https://flutter.dev/docs/get-started/install).
- Dart SDK installed.

### Cloning the Project

1. First, clone this project to your local system.
```
git clone https://github.com/Pillar-Bridge/bridge.git
```

2. Navigate to the project directory.
```
cd bridge
```

### Installing Dependencies

In the project directory, run the following command to install the required packages.
```
flutter pub get
```
### Running the App
Use the following command to run the app:
```
flutter run
```

## Bridge App Frontend Specification
### 1. Tech Stack
- Dart SDK: 3.2.6
- Flutter SDK: Compatible with version >=3.2.6 <4.0.0
- geolocator: 11.0.0
- just_audio: 0.9.36
- record: 5.0.4
- speech_to_text: 6.6.0
  
### 2. Architecture
```
lib
 ┣ api
 ┃ ┣ responses
 ┃ ┃ ┣ api_response.dart
 ┃ ┃ ┣ res_replies.dart
 ┃ ┃ ┣ res_dialogue.dart
 ┃ ┃ ┣ res_message_dialogue.dart
 ┃ ┃ ┣ res_modification_options.dart
 ┃ ┃ ┗ res_place_recommendation.dart
 ┃ ┗ api_client.dart
 ┣ controllers
 ┃ ┗ voice_recorder.dart
 ┣ models
 ┣ ui
 ┃ ┣ constants
 ┃ ┃ ┗ app_theme.dart
 ┃ ┣ screens
 ┃ ┃ ┣ TestScreen.dart
 ┃ ┃ ┣ common_widget_test_screen.dart
 ┃ ┃ ┣ full_text_screen.dart
 ┃ ┃ ┣ select_answer_screen.dart
 ┃ ┃ ┣ select_place_screen.dart
 ┃ ┃ ┣ stt_test_screen.dart
 ┃ ┃ ┣ voice_recognition_screen.dart
 ┃ ┃ ┗ voice_setting_screen.dart
 ┃ ┗ widgets
 ┃ ┃ ┣ buttons
 ┃ ┃ ┃ ┣ button_basic.dart
 ┃ ┃ ┃ ┣ button_basic_icon.dart
 ┃ ┃ ┃ ┣ button_current_situation.dart
 ┃ ┃ ┃ ┣ button_select_sentence.dart
 ┃ ┃ ┃ ┣ button_suggestion_sentence.dart
 ┃ ┃ ┃ ┣ button_toggle_icon.dart
 ┃ ┃ ┃ ┣ button_toggle_text.dart
 ┃ ┃ ┃ ┗ button_word_replacement.dart
 ┃ ┃ ┣ progresses
 ┃ ┃ ┃ ┗ progress_threedots.dart
 ┃ ┃ ┗ change_word.dart
 ┣ utils
 ┃ ┗ token_manager.dart
 ┗ main.dart

```

