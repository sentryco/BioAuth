[![codebeat badge](https://codebeat.co/badges/edbf8e35-99f3-45ee-861d-5d3c995b80c8)](https://codebeat.co/projects/github-com-passbook-bioauth-master)
[![Tests](https://github.com/sentryco/BioAuth/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/BioAuth/actions/workflows/Tests.yml)

# BioAuth 🧬

> Biometric authentication kit

## Description

- BioAuth is a Swift library that provides a simple and easy-to-use interface for biometric authentication on iOS devices. It supports both Face ID and Touch ID, and provides a unified API for both methods. 
- BioAuth provides a static context for `LAContext` and a method to initiate the biometric authentication process. It also includes utility methods to determine if biometric authentication is available and accessible on the device. 
- The library uses the modern `Result` type for better error handling and includes descriptive error messages for better debugging. It also provides a way to retrieve available BioAuth types, including `touch`, `face`, and `none`.
- BioAuth is designed to be easy to integrate into any project that requires biometric authentication. It is also designed with security in mind, and includes features such as the ability to invalidate the context when the app is closed or goes into the background, and a timer to invalidate the context after a period of inactivity.

### Features
- Provides a way to retrieve available BioAuth types, including `touch`, `face`, and `none`
- Includes descriptive error messages for better debugging
- Uses the modern `Result` type for better error handling

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

### Gotchas:
- To debug threading issues: Consider using `Thread Sanitizer in Xcode`
- The first time a user uses your app with Biometry. There will be a popup asking to allow face-id or touch id

### Resources:
- http://michael-brown.net/2018/touch-id-and-face-id-on-ios/
- https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_secure_enclave
- Passlock screen: https://github.com/yankodimitrov/SwiftPasscodeLock and https://github.com/keepassium/KeePassium/blob/master/KeePassium/general/PasscodeInputVC.swift
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
- Assert if user has a passcode enabled  https://bencoding.com/2017/01/04/checking-if-device-passcode-is-enabled/
- Some code regarding auto lock of database: https://github.com/mozilla-lockwise/lockwise-ios/blob/master/Shared/Common/Helpers/AutoLockSupport.swift
- Obfuscate screen when app resigns active  https://github.com/mssun/passforios/blob/master/pass/AppDelegate.swift

### Todo: 
- Re-name to "BiometryAuth"? or "Biometry"? or keep as is? keep as is, Apple might name something Biometry in the future and then you have an overlap issue etc 
- Improve this package see: https://github.com/rushisangani/BiometricAuthentication
- Add autolock after 3min for macOS by just invalidating bioauty, if the app has entered background and not entered foreground etc. Mac: We could simply start autolock after 3 mins  iPhone: when the app enters background mode, its locked. no need for timeout here
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
- Remove unit tst, replace with uitests?
- The error handling in the LAError+Extension.swift file could be enhanced by providing more specific and user-friendly error messages, especially for biometric authentication errors. This could improve the user experience by making the errors more understandable.
- Updating and Refining .swiftlint.yml The SwiftLint configuration file has several rules commented out. Reviewing and deciding on the necessary rules to enforce coding standards consistently across the project would help in maintaining code quality.
- Add gotchas for common errors in the readme
- Add example proj
- remove unit-tests?
