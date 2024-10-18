import Foundation
import LocalAuthentication

extension AuthController {
   /**
    * - Abstract: Represents the result of an authentication attempt, either success or failure with an error.
    * - Description: This typealias represents the result of an authentication
    *                attempt. It is a `Result` type that can be either a success
    *                with a boolean value indicating the authentication outcome
    *                or a failure with an `LAError` object describing the error.
    * - Parameters:
    *   - success: A boolean value indicating the success of the authentication process.
    *   - error: An `LAError` object describing the error that occurred during the authentication process.
    */
   public typealias AuthenticateResult = Result<Bool, LAError>
   /**
    * Represents a closure that handles the result of an authentication attempt.
    * - Description: This closure is used as a completion handler for
    *                authentication operations. It takes an
    *                `AuthenticateResult` parameter, which is a `Result` type
    *                that can be either a success with a boolean value
    *                indicating the authentication outcome or a failure with an
    *                `LAError` object describing the error.
    * - Parameter result: A `Result` object that contains either a success
    *                     boolean value or an `LAError` object describing the
    *                     error that occurred during the authentication process.
    */
   public typealias OnComplete = (AuthenticateResult) -> Void
   /**
    * Completion callback typealias for permitAndAuth
    * - Description: This typealias is used as a completion handler for the
    *                `permitAndAuth` function. It takes a boolean parameter
    *                indicating the success of the authentication process.
    * - Parameter success: A boolean value indicating the success of the
    *                      authentication process.
    */
   public typealias CompletionAlias = (_ success: Bool) -> Void
}
