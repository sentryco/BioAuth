import Foundation
import LocalAuthentication
//import Logger
/**
 * Asserter
 * - Description: The `Asserter` extension for `BioAuth` provides utility
 *                methods to determine if biometric authentication is available
 *                and accessible on the device. It includes checks for both
 *                biometric-only and biometric-or-passcode authentication
 *                options, logging any issues encountered during the evaluation
 *                of the device's authentication policies.
 * - Note: Possible upgrades, has usesTouchID, deviceAuthenticationAvailable, usesFaceID, usesBiometric : https://github.com/mozilla-lockwise/lockwise-ios/blob/master/Shared/Common/Helpers/BiometryManager.swift
 */
extension BioAuth {
   /**
    * Asserts if the device can use biometric authentication
    * - Description: This method checks if the device supports biometric
    *                authentication. It evaluates the device's policy to
    *                determine if biometric authentication is available,
    *                providing a boolean result that indicates the availability
    *                of this authentication option.
    * - Note: Alternative name: `isBiometricsAvailable`
    * - Fixme: ⚠️️ add some more doc which context this is used in etc
    * - Fixme: ⚠️️ Make this a method that throws? `getAccessible`? So that we can prompt the user with an error message, etc? probably yes
    * - Fixme: ⚠️️ add example in doc
    */
   public static var isAccessible: Bool {
      //Logger.info("\(Trace.trace())") // Log that the function has been called
      guard let context: LAContext = Self.context else { // Check if the context is accessible
         //Logger.warn("\(Trace.trace()) - context not accessible", tag: .security) // if not, log a warning
         return false // return false
      }
      var authError: NSError? // Declare an optional NSError variable to hold any authentication errors
       // Check if the device supports biometric authentication
      guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
         // If not, log the error message
         //Logger.warn("\(Trace.trace()) - Err: \(LAError.getErrorMessage(errorCode: (authError?._code)!))", tag: .security)
         return false // Return false
      }
      return true // Return true if biometric authentication is available
   }
   /**
    * Asserts if the device can use biometric authentication or passcode authentication.
    * - Description: This method checks if the device supports biometric
    *                authentication with the option to fallback on passcode
    *                authentication. It evaluates the device's policy to
    *                determine if either authentication method is available,
    *                providing a boolean result that indicates the availability
    *                of these authentication options.
    * - Note: Alternative name: `isBiometricOrPasscodeAuthenticationAvailable`
    * - Fixme: ⚠️️ add some more doc which context this is used in etc
    * - Fixme: ⚠️️ Maybe merge isAccessible and isAuthAvailable. and just pass LAPolacy as a param?
    */
   public var isAuthAvailable: Bool {
      guard let context: LAContext = Self.context else { /*Logger.warn("\(Trace.trace()) - context not accessible", tag: .security);*/ return false } // check if the context is accessible
      var authError: NSError? // Declare an optional NSError variable to hold any authentication errors
      // check if the device supports biometric or passcode authentication
      guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) else {
         // if not, log the error message
         //Logger.warn("\(Trace.trace()) - Err: \(LAError.getErrorMessage(errorCode: (authError?._code)!))", tag: .security)
         return false // return false
      }
      return true // return true if biometric or passcode authentication is available
   }
}
