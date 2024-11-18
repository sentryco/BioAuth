import Foundation
import LocalAuthentication
/**
 * A class for handling biometric authentication.
 * - Description: BioAuth is a class that provides methods for handling
 *                biometric authentication such as Face ID or Touch ID. It
 *                provides a static context for LAContext and a method to
 *                initiate the biometric authentication process. It is designed
 *                to be easy to use and integrate into any project that requires
 *                biometric authentication.
 * - Fixme: ⚠️️ There are newer and better BioAuth libs out there now. Consider improving this class with inspiration from those libraries.
 * - Fixme: ⚠️️ Check the library from the Shortcut on GitHub, in their Shortcut Foundation repository, for example.
 */
public final class BioAuth {}

extension BioAuth {
   /**
    * A convenient place for apps to store the `LAContext`
    * - Description: This static variable holds an instance of LAContext,
    *                which is used for managing biometric authentication. It
    *                provides a centralized context for performing
    *                authentication and evaluating access control policies. It
    *                can be used to evaluate whether the device supports
    *                biometric authentication and to initiate the
    *                authentication process.
    * - Fixme: ⚠️️ add some doc why we need to store LAContext, it's side effects etc
    * - Fixme: ⚠️️ Consider making this lazy and a singleton
    * - Fixme: ⚠️️⚠️️⚠️️ We should probably call `context.invalidate()` when the app is closed or goes into the background, and use a timer to invalidate the context after a period of inactivity.
    */
   nonisolated(unsafe) public static var context: LAContext?
   /**
    * Starts biometric authentication.
    * - Description: This method initializes the biometric authentication process
    *                by creating a new `LAContext` and evaluating the device's
    *                policy for biometric authentication. If the device supports
    *                biometric authentication, it prompts the user for
    *                authentication using Face ID or Touch ID. The result of the
    *                authentication attempt, whether successful or an error, is
    *                then passed to the completion handler.
    * - Remark: You can determine which "biometric-type" is used with: `context.biometryType != .none`
    * - Remark: If context crashes in the simulator, it means biometric authentication is not enrolled for the simulator. Make sure your simulator has `FaceID` in `MacMenu -> Feature -> FaceID/TouchID -> enrolled` set to true. Otherwise, BioAuth will begin to loop and eventually crash.
    * - Note: Consider adding logic from this repository: https://github.com/rushisangani/BiometricAuthentication
    * - Note: Alterntive names: `auth..` or `engage..`? or `doBioAuth..`
    * - Parameter complete: The completion handler with a payload as the result type
    * - Fixme: ⚠️️ Add info regarding the different eval parameters and their purpose
    */
   @MainActor // ⚠️️ required or else compiler shows error. also this should only be on mainthread
   public static func initBioAuth(complete: @escaping Complete) {
      let context: LAContext = .init() // create a new instance of LAContext
      var authError: NSError? // declare an optional NSError variable to hold any authentication errors
      guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else { // check if the device supports biometric authentication
         let errMsg: String = LAError.getErrorMessage(errorCode: authError?._code) // if not, get the error message
         // Logger.warn("\(Trace.trace()) - errMsg: \(errMsg)") // log the error message
         complete(.failure(.authFailed(reason: errMsg))) // notify the user that authentication failed
         return // exit the function
      }
      context.evaluatePolicy( // Evaluates the user's identity using biometrics. This method uses the LAContext instance to check if the user can be authenticated using a biometric method (Face ID or Touch ID) based on the current device policy. It presents a system dialog to the user prompting them to authenticate using their biometric data.
            .deviceOwnerAuthenticationWithBiometrics, // The policy to evaluate for biometric authentication
            localizedReason: BioAuth.myLocalizedReasonString // The localized reason for the authentication prompt
         ) { (success: Bool, evaluateError: Error?) in // if biometric authentication is supported, evaluate the policy
         DispatchQueue.main.async {
            if success { // if authentication is successful
               complete(.success((successText, context))) // notify the user that authentication succeeded
            } else { // if authentication fails
               let reason: String = (evaluateError as? LAError)?.readableErrorMessage ?? "Unknown error" // get the error message
               complete(.failure(.authAccessFailed(reason: reason))) // notify the user that authentication access failed
            }
         }
      }
   }
}
