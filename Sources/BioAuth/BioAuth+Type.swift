import Foundation
import LocalAuthentication
/**
 * Type aliases used for biometric authentication
 */
extension BioAuth {
   /**
    * The type signature for the payload returned by biometric authentication
    * - Description: Represents the data returned upon successful biometric
    *                authentication, containing a message and the LAContext used
    *                for authentication.
    * - Fixme: ⚠️️ Potentially add a title and description tuple to the result in the future?
    * - Fixme: ⚠️️ make this a struct?
    */
   public typealias BAPayload = (
      msg: String, // The message to display in the authentication prompt
      context: LAContext // The context to use for the authentication
   )
   /**
    * New
    * - Description: Represents the outcome of a biometric authentication
    *                attempt. It can either hold a successful payload containing
    *                a message and the LAContext used for authentication, or an
    *                error indicating the failure reason encapsulated in a
    *                `BioAuthError`.
    */
   public typealias ResultType = Result<BAPayload, BioAuthError>
   /**
    * The type signature for the completion handler used in biometric authentication
    * - Description: This is a type alias for the completion handler used in
    *                biometric authentication. It takes a `ResultType` as an
    *                argument, which represents the outcome of a biometric
    *                authentication attempt. The `ResultType` can either hold a
    *                successful payload containing a message and the LAContext
    *                used for authentication, or an error indicating the failure
    *                reason encapsulated in a `BioAuthError`.
    */
   public typealias Complete = (ResultType) -> Void
}
