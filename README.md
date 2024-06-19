# Feeds!

<img src="https://github.com/lizan-prad/Feeds/assets/96415013/70e04e5b-7190-4d81-9cdf-16cdb41dae45" alt="LaunchScreen" width="200" height="420">
<img src="https://github.com/lizan-prad/Feeds-Unsplash/assets/96415013/d3ddbfa7-5aec-43e7-b85a-3f422c59202c" alt="FeedsList" width="200" height="420">
<img src="https://github.com/lizan-prad/Feeds-Unsplash/assets/96415013/13316aee-b48f-4fcf-9c78-558ef18208fa" alt="PostDetails" width="200" height="420">

## Overview

Feeds is an iOS application that displays a list of posts fetched from a remote API (Unsplash). The app supports features such as infinite scrolling, image caching, and offline access through local caching. The project uses MVVM-C architecture, Combine framework for reactive programming, and Core Data for local storage.

## Features

- Fetch and display posts from a remote API
- Infinite scroll to load more posts as the user scrolls
- Image caching to avoid redundant network calls
- Local caching to support offline access
- Graceful error handling and user-friendly error messages

## Requirements

- Xcode 12.5 or later
- iOS 14.0 or later
- Swift 5.3 or later

## Setup Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/lizan-prad/Feeds.git
cd TeletronincsAssessment
```

### 2. Open the Project in Xcode
Open `TeletronincsAssessment.xcodeproj` in Xcode.

### 3. Install Dependencies
- Lottie-swift: Library for animations (added to `LaunchAnimationViewController`)
- Build the Podfile before building the project by:
```sh
pod install
```
- Make sure you set the deploymentTarget for the `lottie-ios` to `ios 12`
- Ensure you have the latest Xcode and iOS SDK installed.
- Make sure to set the `User Script Sandboxing` to `No` in the `Build Settings` for each Target (including UITests/UnitTests) as shown below:
<img src="https://github.com/lizan-prad/Feeds/assets/96415013/060b2446-52b3-4e72-96c8-7ede72c94404" alt="Build Settings" width="450" height="80">

### 4. Build and Run the Project
Select the target device or simulator and press Cmd + R to build and run the project.

## Running Tests
FYI: Don't forget to comment the `self.savePostsWithAlbumsAndPhotos(posts: posts)` in `PostListViewModel` before starting the UITests

- Unit Tests
Unit tests are located in the `TeletronincsAssessmentTests` target. To run the unit tests:
- Select the TeletronincsAssessmentTests scheme.
Press Cmd + U to run the tests.
UI Tests
UI tests are located in the `TeletronicsAssessmentUITests` target. To run the UI tests:
- Select the `TeletronincsAssessmentUITests` scheme.
Press Cmd + U to run the tests.

## API Documentations (Unsplash)

- The `baseUrl` is defined in the `NetworkManager.swift` file and requires the `client_id` as a url parameter to operate.
- The `Configuration.swift` files container the `clientId` which is retrived from the `info.plist` for each targets.
- The info.plist contains two client ids i.e. `ClientID` & `ClientID-2`, as the API liminations are 50 requests/hour.
- Please replace the `clientId` key with the other, incase of limitation on the API.

## Assumptions

- API Availability: The remote API used for fetching pictures is available and stable. If the API is down or unreachable, the app will show an error message to the user.
- Image URLs: It is assumed that albums have valid image URLs. In a real-world scenario, proper validation and error handling would be necessary.
- Infinite Scroll: The API supports pagination and returns a predictable number of user albums per page. The current implementation assumes that fetching these picture albums will return a non-empty response until there are no more posts.
- Core Data Model: The Core Data model for caching picture albums are set up correctly. The model includes attributes for id, links, urls, descriptions and user as required by the `PictureEntity` entity.

## Project Structure

- Model: Contains data models and Core Data entities.
- ViewModel: Contains view models for managing data and state.
- View: Contains UI components and view controllers.
- Coordinator: Contains the `AppCoordinator` for managing navigation.
- Service: Contains network and caching services.
- Helpers: Contains utility classes and extensions.
- Resources: Contains `AppDelegate` class and `TeletronicsAssessment.xcdatamodeld`.
- Tests: Contains unit and UI tests.

## Contact

For any questions or issues, please open an issue on the repository or contact lizan1895@gmail.com.
