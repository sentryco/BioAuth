[![codebeat badge](https://codebeat.co/badges/edbf8e35-99f3-45ee-861d-5d3c995b80c8)](https://codebeat.co/projects/github-com-passbook-bioauth-master)
[![Tests](https://github.com/sentryco/BioAuth/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/BioAuth/actions/workflows/Tests.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-blue.svg)]()

# BioAuth 🧬

> Biometric authentication kit

## Description

- BioAuth is a Swift library that provides a simple and easy-to-use interface for biometric authentication on **iOS and macOS** devices. It supports both Face ID and Touch ID, and provides a unified API for both methods.
- BioAuth includes utility methods to determine if biometric authentication is available and accessible on the device.
- The library uses the modern `Result` type for better error handling and includes descriptive error messages for improved debugging.
- Designed with security in mind, BioAuth features context invalidation when the app is closed or goes into the background, and a timer to invalidate the context after a period of inactivity.

### Features

- **Cross-Platform Support**: Works seamlessly on both iOS and macOS devices.
- **Unified Biometric Types**: Retrieve available authentication types (`touch`, `face`, and `none`).
- **Singleton `AuthController`**: Centralized management of biometric authentication state.
- **Automatic Context Invalidation**: Security feature that invalidates the context when the app enters the background or after a period of inactivity.
- **Descriptive Error Messages**: Provides detailed error information for easier debugging.
- **Modern Error Handling**: Utilizes Swift's `Result` type for efficient error management.

### Prerequisites:
- Add `Privacy - Face ID Usage Description` to `This app uses Face ID to confirm your identity`
Raw infoplist: 
```xml
<key>NSFaceIDUsageDescription</key> 
<string>This app uses Face ID to confirm your identity</string> 
```
- Ensure simulator has Biometry enrolled.
- Use Match face to debug Biometry authentication 

### Installation via Swift Package Manager (SPM)

You can add BioAuth to your project via Swift Package Manager, which is integrated into the Swift build system as of Swift 5.9. To add BioAuth to your project, modify your `Package.swift` file to include the following dependency:

```swift
.package(url: "https://github.com/sentryco/BioAuth", branch: "main")
```

This will configure your project to use the `main` branch of the BioAuth library from the specified GitHub repository.

### Example (mac / iOS)

There is also an ExampleApp xcodeproj with working example for iOS and macOS

```swift
import BioAuth
// Asserts if the device can use biometric authentication
print(BioAuth.isAccessible) // true false
// Returns the name of biometric authentication method
print(BioAuthType.type) // .face
// Starts biometric authentication
BioAuth.initBioAuth { result in
   switch result {
   case .success(let desc): print(desc.msg)
   // - Fixme: ⚠️️ might need to cast error as BioAuthError to get correct localizedDescription
   case .failure(let error): print(error.localizedDescription)
   }
}
```

**AuthController**

```swift
import BioAuth

// Check if the device can use biometric authentication
print(BioAuth.isAccessible) // true or false

// Get the available biometric authentication type
print(BioAuthType.type) // .face, .touch, or .none

// Start biometric authentication using AuthController
AuthController.shared.permitAndAuth { success in
    if success {
        print("User authenticated successfully")
    } else {
        print("Authentication failed")
    }
}
```

**Trigger auth via button**

```swift
import SwiftUI
import BioAuth

struct ContentView: View {
      @State private var isAuthenticated = false

      var body: some View {
         VStack {
            if isAuthenticated {
                  Text("Welcome!")
            } else {
                  Button("Authenticate") {
                     AuthController.shared.authenticate { success in
                        isAuthenticated = success
                     }
                  }
            }
         }
      }
}
```
 
> [!IMPORTANT]
> **Security Best Practices Review**  
> Conduct a security review of your code to ensure it follows best practices, especially since it deals with sensitive authentication data.
> 
> - Ensure `LAContext` instances are invalidated appropriately.
> - Avoid storing sensitive data in memory longer than necessary.
> - Keep up-to-date with the latest security advisories from Apple
 
### Common Errors and Solutions

- **Error Domain=LAErrorDomain Code=-5 "Authentication failed"**  
   This error occurs when the user fails to authenticate successfully. Ensure the correct biometric data is being used.

- **Error Domain=LAErrorDomain Code=-6 "User canceled"**  
   The user canceled the authentication prompt. Prompt the user again or handle the cancellation gracefully.


### Troubleshooting

- **Simulator Issues**: Ensure your simulator has biometric features enabled. In the simulator, go to **Features > Face ID** or **Features > Touch ID** and select **Enrolled**. Use **Matching Face** or **Matching Fingerprint** to simulate successful authentication.
- **First-Time Authentication**: When the user attempts biometric authentication for the first time, a system prompt will ask for permission. Make sure to handle this scenario appropriately in your app.
- **Biometry Not Enrolled**: If authentication fails with a `LAError.biometryNotEnrolled`, the user needs to enroll Face ID or Touch ID on their device.
- **Passcode Not Set**: If biometric authentication is unavailable due to the device not having a passcode set, prompt the user to enable it in their device settings.
- **Threading Issues**: To debug threading-related problems, consider using the **Thread Sanitizer** in Xcode.

### Resources:
- http://michael-brown.net/2018/touch-id-and-face-id-on-ios/
- https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_secure_enclave
- Passlock screen: https://github.com/yankodimitrov/SwiftPasscodeLock and https://github.com/keepassium/KeePassium/blob/master/KeePassium/general/PasscodeInputVC.swift
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
- Assert if user has a passcode enabled  https://bencoding.com/2017/01/04/checking-if-device-passcode-is-enabled/
- Some code regarding auto lock of database: https://github.com/mozilla-lockwise/lockwise-ios/blob/master/Shared/Common/Helpers/AutoLockSupport.swift
- Obfuscate screen when app resigns active  https://github.com/mssun/passforios/blob/master/pass/AppDelegate.swift

### Todo: 
- Add codecov.io
- Re-name to "BiometryAuth"? or "Biometry"? or keep as is? keep as is, Apple might name something Biometry in the future and then you have an overlap issue etc 
- Improve this package see: https://github.com/rushisangani/BiometricAuthentication
- Add autolock after 3min for macOS by just invalidating bioauty, if the app has entered background and not entered foreground etc. Mac: We could simply start autolock after 3 mins  iPhone: when the app enters background mode, its locked. no need for timeout here
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
- Remove unit tst, replace with uitests?
- The error handling in the LAError+Extension.swift file could be enhanced by providing more specific and user-friendly error messages, especially for biometric authentication errors. This could improve the user experience by making the errors more understandable.
- Updating and Refining .swiftlint.yml The SwiftLint configuration file has several rules commented out. Reviewing and deciding on the necessary rules to enforce coding standards consistently across the project would help in maintaining code quality.
- Add gotchas for common errors in the readme
- Add debugview fenced debug only. We can test BioAuth in preview when target is macOS. iOS does not work. so fence for macos as well maybe?
- remove unit-tests?
- Split this lib into two. Or merge to one
- Localization Support
Add support for localization to reach a wider audience. You can use NSLocalizedString for strings that will be displayed to the user.

```swift
let reason = NSLocalizedString("Unlock with Face ID", comment: "Reason for Face ID authentication")
context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
      // Handle authentication
}
```

- Detect Biometry Changes
Implement functionality to detect if the biometric settings have changed since the user's last authentication. This enhances security by prompting re-authentication if changes are detected.

- Auto-Lock Mechanism for macOS
Add an auto-lock feature that invalidates the authentication context after a period of inactivity or when the app enters the background.

```swift
// In AuthController
private var autoLockTimer: Timer?

func startAutoLockTimer() {
      autoLockTimer?.invalidate()
      autoLockTimer = Timer.scheduledTimer(withTimeInterval: 180, repeats: false) { [weak self] _ in
         self?._context?.invalidate()
      }
}

func resetAutoLockTimer() {
      startAutoLockTimer()
}

// Call `resetAutoLockTimer()` on user interaction
```

- Provide a fallback to passcode or password authentication if biometric authentication is unavailable or fails.

```swift
context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
      // Handle authentication
}
- Manage the lifecycle of `LAContext` instances by invalidating them when no longer needed to prevent unexpected behavior.

```swift
context.evaluatePolicy(policy, localizedReason: reason) { success, error in
   if success {
      // Authentication succeeded
   } else {
      // Authentication failed
   }
   // Invalidate context
   context.invalidate()
}

