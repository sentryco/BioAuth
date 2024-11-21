import Foundation
import LocalAuthentication
/**
 * - Abstract: handles BioAuth state
 * - Description: The AuthController class is responsible for managing the
                  biometric authentication process, providing a centralized point of control
                  for initiating and handling authentication events within the application.
 * - Important: We keep this in a module so that the app and af extension can use it.
 * - Note Used in `BioAuthView+Handler
 * - Note: ref: https://betterprogramming.pub/how-to-implement-faceid-or-touchid-in-ios-f3837cc2ff01
 * - Note: simpler solution: https://www.andyibanez.com/posts/integrating-face-id-touch-id-swiftui/
 * - Note: and https://www.devtechie.com/community/public/posts/145824-user-authentication-with-face-id-touch-id-in-swiftui
 * - Important: ⚠️️ Using this requires setting info.plist: `NSFaceIDUsageDescription`
 * - Note: Alternative name: `BioAuthController` ask copilot to suggest better names?
 * - Fixme: ⚠️️⚠️️ deprecate old BioAuth etc?
 * - Fixme: ⚠️️ merge this and bioAuth. they are essentially the same
 */
public class AuthController { /*: ObservableObject */
   /**
    * Singleton
    * - Description: The `shared` static property provides a globally accessible
    *                instance of `AuthController`, ensuring that only one instance of the class
    *                is used throughout the application. This singleton pattern is used to
    *                coordinate actions that need a single, shared resource, such as biometric
    *                authentication management.
    * - Note: Was observable-object, but we moved to singleton instead
    * - Fixme: ⚠️️ We could also make this an envirotment variable maybe? do some exploration?
    */
   public static let shared: AuthController = .init()
   /**
    * Initializes a new instance of the AuthController.
    * - Description: This initializer sets up a new instance of the
    *                AuthController, which handles biometric authentication state.
    * - Fixme: ⚠️️ Rename to authContext?
    */
   internal var _context: LAContext? = .init()
}
// - Fixme: ⚠️️⚠️️⚠️️ clean up the bellow, and add it to the comments or readme etc 👈

// This code presents a Swift class called LocalAuthenticationService that provides an easy way to use the biometric authentication functionality in your application.
// The static method authenticateWithBiometrics is the one that provides the authentication functionality. This method takes a callback function as a parameter that is executed when the authentication is completed.

// The authenticateWithBiometrics function creates an instance of LAContext, which is an iOS class that provides access to the biometric authentication functionality.
// It checks if the device is compatible with biometric authentication and if the user has set up a fingerprint or face to use as a security measure. If it is compatible,
// the evaluatePolicy method is called on the context with the argument .deviceOwnerAuthenticationWithBiometrics. This method displays a dialog for the user to authenticate using their fingerprint or face.
// The localizedReason argument is a string that is displayed in the dialog to indicate to the user the reason for the authentication request.

// The parameter of evaluatePolicy is a callback block that is called when the user has authenticated. If the user has authenticated successfully, the callback function is called with a Success Result.
// If it does not authenticate successfully, the callback function is called with an Error Result. The error result may be the error returned in case of authentication failure or “No Biometrics Available”
// if the device does not support biometric authentication.

// Before continuing we have to add the NSFaceIDUsageDescription key to our Info.plist, NSFaceIDUsageDescription is an Info.plist key that is used to describe the purpose of using facial recognition technology (Face ID) in the application.
// It is necessary to include this key in your project’s Info.plist file if your application uses Face ID for user authentication.

// The reason for this is that, according to Apple’s development guidelines, all applications that use private system features, such as Face ID, must provide a clear and accurate description of the use of these features.
// This provides transparency for users about how their biometric information will be used, and allows them to make an informed decision.

// LockScreen
// Now, let’s see how we can use the authenticateWithBiometrics function with an example:



//   public init() {
//      Swift.print("🧬 AuthController.init() - set LAContext")
//      Self.context = LAContext()
//   }
//   deinit {
//      Swift.print("🧬 AuthController.deinit")
//      Self.context = nil
//   }
//   /* @Published */public static var biometricType: LABiometryType = .none
