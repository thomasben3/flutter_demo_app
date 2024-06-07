
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

This project includes unit tests to ensure the functionality of the app.

### Running Tests
To run the tests, use the following command:
```sh
flutter test
```


## Build with

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)


## Dependencies

### Basics

- **flutter_bloc**: Simplify the BLoC architecture implementation.
- **equatable**: Allows to compare classes by content instead of memory adress.
- **dio**: Manage http requests.
- **sqflite**: Local database to store the cart items.
- **flutter_localizations**: Manage localization system.
- **shared_preferences**: Local storage to make basics data persistent.

### Decoratives

- **animated_text_kit**: Provide built-in text animations.
- **flutter_animate**: Permit to write cleaner code when using animations.
- **flutter_slidable**: Used only for deleting items from cart.

### Testing

- **bloc_test**: Simplify bloc testing.
- **test**: Default test package.
- **mockito**: Permit to mock classes when testing.
- **build_runner**: Permit to build mockito generated files.
