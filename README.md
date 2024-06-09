
# Flutter demo app

A grocery shopping e-commerce demo application.  
This is my first application built with the BLoC (Business Logic Components) architecture.


## Features

- **Product Listing**: Fetches products from an API and displays them in a list.
- **Add to Cart**: Allows users to add products to their cart.
- **Cart View**: Displays the products that have been added to the cart.
- **Localization**: Manage multiple languages.


## Demo

![](https://github.com/thomasben3/flutter_demo_app/blob/main/app_demo.gif)

## Getting Started

### Prerequisites

Ensure you have Flutter installed on your machine. You can follow the instructions on the official [Flutter installation guide](https://docs.flutter.dev/get-started/install).

### installation

Clone the repository:
```sh
git clone git@github.com:thomasben3/flutter_demo_app.git
```

Navigate to the project directory:
```sh
cd flutter_demo_app
```

Fetch the dependencies:
```sh
flutter pub get
```

### Running the App

run this command:
```sh
flutter run
```

## Testing

This project includes unit and integration tests to ensure the functionality of the app.

### Running Tests
To run the tests, use the following command:
```sh
flutter test
```


## Build with

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)


## Dependencies

### Core Functionality

- **flutter_bloc**: Simplifies the BLoC architecture implementation.
- **equatable**: Allows comparing classes by content instead of memory address.
- **dio**: Manages HTTP requests.
- **sqflite**: Local database for storing cart items.
- **flutter_localizations**: Manages the localization system.
- **hydrated_bloc**: Stores bloc states in local storage.
- **path_provider**: Finds commonly used locations on the filesystem.

### Decorative

- **animated_text_kit**: Provides built-in text animations.
- **flutter_animate**: Allows writing cleaner code when using animations.
- **flutter_slidable**: Used for deleting items from the cart.

### Testing

- **bloc_test**: Simplifies bloc testing.
- **test**: Default test package.
- **integration_test**: Default integration test package.
- **mockito**: Allows mocking classes for testing.
- **build_runner**: Generates files needed by Mockito.
