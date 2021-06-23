# Surveys
Surveys using VIPER architect, simple app that allow user to login and see the surveys list and take the surveys.
- Login screen
- Forgot password screen
- Surveys list screen
- Survey detail (TBD)

## **1. Architecture**
It's written in VIPER using delegation approach. It's quite similar to the traditional version, just that using cummunicate protocols helps us make the responsibility clearer, easy to test and scale up.

Inspire by https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/master/Templates and https://github.com/uber/RIBs.

The overview architect look like this:
![image](https://koenig-media.raywenderlich.com/uploads/2020/02/viper.png)

## **2. Code structure**

Surveys
This consists of files being used in the main target.

- Common: Extend some existing classes/structs such as UIViewController, Constant, Builder...
- Protocols: Declare some protocols/base classes being used across the app such as Presentablt/Interactable/Routable...
- Models: Declare the models/entities used in the app.
- Services: All the API services to interact with BE. Each service is responsible for sending the request to BE and parsing the response or handling failures.
- Screens: Every screen's VIPER components are located in this folder.

- SurveysUnitTests: This contains all unit tests, mock classes and extensions that being used in unit tests such as SurveysTests, MockComponents

- LocalPods
The libs that can be shared between the main target and unit/UI test target are located in LocalPods such as RxSwift, KingFisher...

## **3. Third-party libraries**
Below is the list of third-party libraries that I use in the project:

- **RxSwift/RxCocoa**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well as API requests/responses. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.
- **KingFisher**: Quick and easy download image from internet with elegant caching approach.
- **SkeletonView**: SkeletonView has been conceived to address showing loading state, an elegant way to show users that something is happening and also prepare them for which contents are waiting.
- **Alamofire**: an HTTP networking library written in Swift. Use to handle all URL requests.
- **SnapKit**: a DSL to make Auto Layout easy on both iOS and OS X. Use to make UI layout constraints.
- **KeychainAccess**: a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs extremely easy and much more palatable to use in Swift. Use to get/set credential informations to Keychain.

## **4. Build the project on local**
- After cloning the repo, please run `pod install` from your terminal then open `Surveys.xcworkspace` and try to build the project using Xcode 12+.
It should work without any additional steps.
- Go to the source directory, run `fastlane test` or `bundle exec fastlane tests` to run Unit Tests. It should show a html page contains the test result.

## **5. Checklist**
- [x] Programming language: Swift

- [x] Design app's architecture: VIPER

- [x] UI matches in the attachment
 
- [ ] Dark mode: supported. Try `cmd + shift + A` if you run on simulator.
 
- [x] Unit tests

- [x] Error handling

- [x] Caching handling

- [x] Automatic handle expires token

- [x] Integrated Fastlane

Thanks and have a nice day!
