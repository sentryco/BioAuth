import Foundation
import LocalAuthentication
//import Logger
/**
 * Constants used for biometric authentication
 */
extension BioAuth {
   /**
    * The error message to display to the user when biometric authentication is not enrolled.
    * - Description: This is a constant string that represents the error
    *                message displayed to the user when biometric
    *                authentication is not enrolled on the device. This
    *                typically means that the user has not set up Face ID or
    *                Touch ID on their device.
    * - Note: Alternative names: `notEnrolledErrorMessage` or `notEnrolledErrorString`
    */
   public static let notEnrolled: String = "The operation couldn’t be completed. (TouchID or FaceID Not Enrolled error 0.)"
   /**
    * The localized reason string to display to the user when requesting biometric authentication.
    * - Description: This is a constant string that provides a localized
    *                reason for requesting biometric authentication. This
    *                string is displayed to the user when the system prompts
    *                for biometric authentication, providing context for why
    *                the authentication is needed.
    */
   static let myLocalizedReasonString = "Authenticate using your biometric data"
   /**
    * The success message to display to the user when authentication is successful
    * - Description: This is a constant string that represents the success
    *                message displayed to the user when biometric
    *                authentication is successful. This typically means that
    *                the user has been authenticated using Face-ID or Touch-ID
    *                on their device.
    */
   static let successText: String = "User authenticated successfully"
   /**
    * The error message to display to the user when authentication fails
    * - Description: This is a constant closure that takes an error string as
    *                input and returns a formatted error message. The returned
    *                message indicates that the user did not authenticate
    *                successfully and includes the provided error string for
    *                additional context.
    */
   nonisolated(unsafe) static let errorMsg: (_ errStr: String) -> String = {
      { (errStr: String) in
         "User did not authenticate successfully\n\(errStr)"
      }
   }()
}
