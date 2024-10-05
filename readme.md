[![codebeat badge](https://codebeat.co/badges/edbf8e35-99f3-45ee-861d-5d3c995b80c8)](https://codebeat.co/projects/github-com-passbook-bioauth-master)

# BioAuth 🧬

> Biometric authentication kit

## Description

BioAuth is a Swift library that provides a simple and easy-to-use interface for biometric authentication on iOS devices. It supports both Face ID and Touch ID, and provides a unified API for both methods. 

BioAuth provides a static context for `LAContext` and a method to initiate the biometric authentication process. It also includes utility methods to determine if biometric authentication is available and accessible on the device. 

The library uses the modern `Result` type for better error handling and includes descriptive error messages for better debugging. It also provides a way to retrieve available BioAuth types, including `touch`, `face`, and `none`.

BioAuth is designed to be easy to integrate into any project that requires biometric authentication. It is also designed with security in mind, and includes features such as the ability to invalidate the context when the app is closed or goes into the background, and a timer to invalidate the context after a period of inactivity.


### Features
- Provides a way to retrieve available BioAuth types, including `touch`, `face`, and `none`
- Includes descriptive error messages for better debugging
- Uses the modern `Result` type for better error handling

### Examples:
```swift
BioAuthType.type // .face

// Initialize BioAuth and handle the result using the `Result` type
BioAuth.initBioAuth { [weak self] result in
   switch result {
   case .success(let desc): notifyUser(desc) // If the result is successful, notify the user with the description
   case .failure(let error): notifyUser("Error", error.localizedDescription) // If the result is a failure, notify the user with the error message
   }
}

// Define a function to notify the user with an alert
func notifyUser(_ msg: String, err: String?) {
   let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert) // Create a new alert controller with the given title, message, and style
   let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil) // Create a new cancel action with the given title and style, and set the handler to `nil`
   alert.addAction(cancelAction) // Add the cancel action to the alert controller
   self.present(alert, animated: true, completion: nil) // Present the alert controller with animation and no completion handler
}
```

### Example (mac)
```swift
BioAuth.initBioAuth { [weak self] result in
   switch result {
   case .success(let desc): self?.notifyUser(desc.msg)
   // - Fixme: ⚠️️ might need to cast error as BioAuthError to get correct localizedDescription
   case .failure(let error): self?.notifyUser("Error", err: error.localizedDescription)
   }
}
func notifyUser(_ msg: String, err: String? = nil) {
   let alert = NSAlert() // Create a new `NSAlert` instance
   alert.messageText = "Biometric authentication" // Set the message text of the alert to "Biometric authentication"
   alert.informativeText = msg // Set the informative text of the alert to the given message
   alert.alertStyle = .warning // Set the alert style to `.warning`
   alert.addButton(withTitle: "OK") // Add an "OK" button to the alert
   alert.addButton(withTitle: "Cancel") // Add a "Cancel" button to the alert
   let res = alert.runModal() // Run the alert modally and get the result
   if res == .alertFirstButtonReturn { // If the user clicked the "OK" button, print "ok"
      Swift.print("ok")
   } else if res == .alertSecondButtonReturn { // If the user clicked the "Cancel" button, print "cancel"
      Swift.print("cancel")
   }
}
```

### Resources:
- http://michael-brown.net/2018/touch-id-and-face-id-on-ios/
- https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_secure_enclave
- Passlock screen: https://github.com/yankodimitrov/SwiftPasscodeLock and https://github.com/keepassium/KeePassium/blob/master/KeePassium/general/PasscodeInputVC.swift
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
- Assert if user has a passcode enabled  https://bencoding.com/2017/01/04/checking-if-device-passcode-is-enabled/
- Some code regarding auto lock of database: https://github.com/mozilla-lockwise/lockwise-ios/blob/master/Shared/Common/Helpers/AutoLockSupport.swift
- Obfuscate screen when app resigns active  https://github.com/mssun/passforios/blob/master/pass/AppDelegate.swift

### License:
This software is licensed under the MIT License. Please ensure to adhere to the licensing terms when using, modifying, or distributing this code.

### Todo: 
- Re-name to "BiometryAuth"? or "Biometry"? or keep as is? keep as is, Apple might name something Biometry in the future and then you have an overlap issue etc 
- Improve this package see: https://github.com/rushisangani/BiometricAuthentication
- Add autolock after 3min for macOS by just invalidating bioauty, if the app has entered background and not entered foreground etc. Mac: We could simply start autolock after 3 mins  iPhone: when the app enters background mode, its locked. no need for timeout here
- Detecting if the Touch ID/Face ID configurations have changed since the user’s last authentication. Resource to solve: https://www.cognizantsoftvision.com/blog/the-missing-step-when-using-face-id-or-touch-id-in-your-ios-app/
