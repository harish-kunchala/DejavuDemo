# DejavuDemo

This project demonstrates how to integrate the Dejavu package into an iOS app to enhance network testing. It uses SwiftUI for the user interface and JSONPlaceholder to simulate network calls.

## Table of Contents
- Introduction
- Features
- Requirements
- Installation
- Usage
- Project Structure
- Contributing
- License

## Introduction

In the world of iOS development, ensuring the reliability and speed of network-dependent tests can be challenging. This project showcases how to use Dejavu, an open-source network mocking library by Esri, to record and replay network requests, making tests faster and more reliable.

## Features

- **Network Manager**: Handles network requests using `URLSession`.
- **Dejavu Integration**: Records and replays network requests for reliable testing.
- **SwiftUI Interface**: Displays user data fetched from JSONPlaceholder.
- **Error Handling**: Gracefully handles and displays errors.

## Requirements

- Xcode 12.0 or later
- iOS 14.0 or later
- Swift 5.3 or later

## Installation

1. **Clone the repository**:
   ```sh
   git clone https://github.com/harish-kunchala/DejavuDemo.git
   cd DejavuDemo
   ```

2. **Open the project in Xcode**:
   ```sh
   open DejavuDemo.xcodeproj
   ```

3. **Install dependencies**:
   - Go to `File > Add Packages...`
   - Enter the Dejavu GitHub repository URL: `https://github.com/Esri/dejavu`
   - Select the latest version and add it to your project.

## Usage

1. **Run the app**:
   - Select the `DejavuDemo` target.
   - Press `Cmd + R` to build and run the app.

2. **Run the tests**:
   - Select the `DejavuDemoTests` target.
   - Press `Cmd + U` to run the tests.

## Project Structure

- **DejavuDemo/**: Contains the main app code.
  - `NetworkManager.swift`: Handles network requests.
  - `ContentView.swift`: SwiftUI view displaying user data.
- **DejavuDemoTests/**: Contains the test code.
  - `DejavuDemoTests.swift`: Tests using Dejavu to mock network requests.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
