import Foundation
import LocalAuthentication

extension LAError {
   /**
    * Improves the error description for a given error code
    * - Description: This function takes an error code as input and returns a
    *                human-readable error message corresponding to that error
    *                code. The error code is expected to be one of the
    *                LAError codes. If the error code is nil or not a valid
    *                LAError code, it returns a default "Unknown error" message.
    * - Fixme: ⚠️️ Specialize error message by adding `bio-auth` type in parameter
    * - Parameter errorCode: The error code from the operating system
    * - Returns: The error message for the given error code
    */
   public static func getErrorMessage(errorCode: Int?) -> String {
      guard let errorCode: Int = errorCode,
            let laError: LAError.Code = .init(rawValue: errorCode) else {
         // If the error code is nil or cannot be converted to an LAError.Code, return an unknown error message
         return "Unknown error"
      }
      // Return the readable error message for the given error code
      return laError.readableErrorMessage
   }
   /**
    * Returns a human-readable error message for the LAError.
    * - Description: This property provides a human-readable error message for
    *                the LAError. It uses the error code to determine the
    *                appropriate message, making it easier to understand the
    *                nature of the error.
    * - Returns: A human-readable error message for the LAError.
    * - Example: "Biometry is locked out." or "Biometry is not available on this device."
    */
   public var readableErrorMessage: String {
      // Return the human-readable error message for the LAError.Code
      self.code.readableErrorMessage
   }
}
/**
 * Getter
 */
extension LAError.Code {
   /**
    * Returns a human-readable error message for the LAError.
    * - Description: This property provides a human-readable error message for
    *                the LAError.Code. It uses the error code to determine the
    *                appropriate message, making it easier to understand the
    *                nature of the error.
    * - Returns: A human-readable error message for the LAError.
    * - Example: "Biometry is locked out." or "Biometry is not available on this device."
    */
   public var readableErrorMessage: String {
      switch self {
      case .authenticationFailed:
         // if authentication fails, return this message
         return "Authentication failed"
      case .userCancel:
         // if the user cancels authentication, return this message
         return "User canceled"
      case .systemCancel:
         // if the system cancels authentication, return this message
         return "System canceled"
      case .passcodeNotSet:
         // if passcode is not set, return this message
         return "Please goto the settings & turn on passcode"
      case .biometryNotAvailable:
         // if biometric authentication is not available, return this message
         return "TouchI or FaceID not available"
      case .biometryNotEnrolled:
         // if biometric authentication is not enrolled, return this message
         return "TouchID or FaceID not anrolled"
      case .biometryLockout:
         // if biometric authentication is locked out, return this message
         return "TouchID or FaceID lockout please goto the Settings & Turn On Passcode"
      case .appCancel:
         // if the app cancels authentication, return this message
         return "App canceled"
      case .invalidContext:
         // if the context is invalid, return this message
         return "Invalid context"
      case .userFallback:
         // if the user falls back to password authentication, return this message
         return "User fallback"
      case .notInteractive:
         // if authentication is not interactive, return this message
         return "Not interactive"
      default:
         // if policy evaluation fails, return this message
         return "Could not evaluate policy"
      }
   }
}
// ⚠️️ new
extension LAError {
      /// Provides a user-friendly error message for each LAError code
      var localizedMessage: String {
         switch self.code {
         case .authenticationFailed:
            return "Authentication was not successful because the user failed to provide valid credentials."
         case .userCancel:
            return "Authentication was canceled by the user."
         case .userFallback:
            return "Authentication was canceled because the user tapped the fallback button."
         case .systemCancel:
            return "Authentication was canceled by the system."
         case .passcodeNotSet:
            return "Authentication could not start because the passcode is not set on the device."
         case .biometryNotAvailable:
            return "Authentication could not start because biometric authentication is not available on the device."
         case .biometryNotEnrolled:
            return "Authentication could not start because the user has not enrolled in biometric authentication."
         case .biometryLockout:
            return "Authentication was not successful because there were too many failed biometric attempts and biometry is now locked."
         default:
            return self.localizedDescription
         }
      }
}
   
// Alternative error messages: (more comprehensive?)
// There was a problem verifying your identity
// User pressed cancel
// Face ID/Touch ID is not available
// Face ID/Touch ID is not set up
// You pressed password, Password option selected
// Face ID/Touch ID is locked.
// "Face ID/Touch ID may not be configured"
