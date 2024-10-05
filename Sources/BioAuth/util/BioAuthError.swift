import Foundation
/**
 * Used as errors in the completion block when calling the `initBioAuth` method
 * - Description: Enumerates the various errors that can occur during the biometric authentication process. Each case provides a specific type of error that can be used to identify what went wrong during authentication.
 */
public enum BioAuthError: Error {
   /**
    * Access to biometric authentication not given
    * - Parameter reason: A string describing the reason why access to biometric authentication was not given.
    */
   case authAccessFailed(reason: String)
   /**
    * Biometric authentication failed
    * - Parameter reason: A string describing the reason why biometric authentication failed.
    */
   case authFailed(reason: String)
}
/**
 * Extension for `BioAuthError` enum
 */
extension BioAuthError {
   /**
    * Returns a localized description of the error
    * - Returns: A string describing the error
    */
   public var localizedDescription: String {
      switch self {
      case .authAccessFailed(let reason): reason // Access to biometric authentication not given.
      case .authFailed(let reason): reason // Biometric authentication failed.
      }
   }
}
