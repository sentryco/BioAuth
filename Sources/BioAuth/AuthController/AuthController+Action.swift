import Foundation
import LocalAuthentication
/**
 * - Description: This extension provides additional functionality to the
 *                AuthController class, including methods for handling biometric
 *                authentication and permission requests.
 * - - Fixme: ⚠️️ Clean up this code
 */
extension AuthController {
   /**
    * Ask permission and auth
    * - Abstract: - Fixme: ⚠️️ add this
    * - Description: This method requests the user's permission for biometric
    *                authentication and, upon granting permission, proceeds to
    *                authenticate the user using their biometric data (e.g., Face
    *                ID or Touch ID). It utilizes the `askBiometricAvailability`
    *                method to determine if biometric authentication is possible
    *                and then calls the `authenticate` method to perform the
    *                actual authentication process. The result of the
    *                authentication attempt is returned via the `complete`
    *                closure, which takes a Boolean indicating success or
    *                failure.
    * - Fixme: ⚠️️ Also return the error, so that we can give the user feedback regarding what is wrong etc
    * - Fixme: ⚠️️ Add example to this comment?
    * - Parameter complete: A closure that is called when the authentication process is complete, indicating success or failure.
    */
   public func permitAndAuth(complete: /*@escaping */CompletionAlias?) {
      // Swift.print("🧬 AuthController.permitAndAuth")
      guard self.askBiometricAvailability() else { /*(_ error: Error?) in*/
         complete?(false) // Calls the completion handler with a false value indicating authentication failed
         return // Exits the function early
      }
      self.authenticate { (_ result: AuthController.AuthenticateResult) in
         switch result { // Switches on the result of the authentication attempt
         case .success: // If the authentication was successful
            //Swift.print("success - Thread.isMainThread: \(Thread.isMainThread) Thread.current.name: \(String(describing: Thread.current.name))")
//            DispatchQueue.main.async {
               complete?(true) // Calls the completion handler with a true value indicating success
//            }
         case .failure(let error): // If the authentication failed
            //Swift.print("authenticate - error: \(error)") // Logs the error to the console
//            DispatchQueue.main.async {
               complete?(false) // Calls the completion handler with a false value indicating failure
//            }
         }
      }
   }
   /**
    * Checks if user has given access to bioauth
    * - Abstract: - Fixme: ⚠️️ add this
    * - Description: With this method, I will check if we can use any biometric
    *                authentication. If the user did not allow our first-time pop-up
    *                about FaceID or turned the biometric data toggle off from our
    *                app menu, it will give us an error based on that. The function
    *                will have a closure to act on it so we can use it on our VC or
    *                View. In this function, we’ll check if we can access biometric
    *                authentication with an inout variable to tell us what went
    *                wrong as NSError data.
    * - Note: Alternative name: `checkPermission`
    * - Parameter completion: A closure that is called when the biometric authentication availability check is complete, indicating whether biometric authentication is available or not.
    * - Fixme: ⚠️️ Return error in tuple, see legacy BioAuth etc
    * - Fixme: ⚠️️ add LAPolacy as param
    * - Fixme: ⚠️️ remove this
    */
   @discardableResult
   public func askBiometricAvailability() -> Bool { /*completion: @escaping (Error?) -> Void*/
      //Swift.print("🧬 AuthController.askBiometricAvailability")
      if let context: LAContext = self.context { // Checks if the LAContext instance is available
         var error: NSError? // Initializes an optional NSError variable to handle potential errors
         if context.canEvaluatePolicy( // Evaluates the policy for biometric authentication
            .deviceOwnerAuthenticationWithBiometrics, // Specifies the policy to evaluate for biometric authentication
            error: &error // Passes a reference to an error variable to capture any errors that occur
         ) {
            // Self.biometricType = context.biometryType
            // completion(nil)
            return true // Returns true if the biometric authentication is available and can be used
         } else {
            // completion(error)
            // Swift.print("askBiometricAvailability - error: \(String(describing: error))")
            return false // Returns false indicating biometric authentication is not available
         }
      } else {
         Swift.print("⚠️️ Context not available")
         return false
      }
   }
   /**
    * Authenticates the user using biometric authentication.
    * - Abstract: Now, we’ll add our authenticate function. This function will
    *             have a result builder that will take a boolean success case or
    *             LAError, which Swift provides us. Thus, we can use every case
    *             Apple gives us as an error. You don’t have to manipulate every
    *             case, but knowing which suits Apple may throw is crucial.
    * - Description: This function attempts to authenticate the user using
    *                biometric methods such as Face ID or Touch ID. It uses a
    *                result builder to handle the success or failure of the
    *                authentication attempt. The function leverages the LAError
    *                provided by Swift to handle various error cases that may
    *                occur during the authentication process.
    * - Parameter completion: A closure that is called when the biometric authentication is complete, indicating whether the authentication was successful or not.
    */
   public func authenticate(completion: /*@escaping */OnComplete?) {
//      Swift.print("🧬 AuthController.authenticate() context: \(String(describing: self.context))")
      guard let context: LAContext = self.context else {
         let err = NSError(domain: "LAContext not available", code: 0)
         let error = LAError(_nsError: err)
         completion?(.failure(error))
         return
      }
      canEval(context: context, completion: completion)
   }
   /**
    * Evaluates if biometric authentication can be performed with the given context
    * - Description: This function checks if the device supports and is configured for biometric authentication using the provided LAContext.
    *                If biometric authentication is available, it proceeds to perform the authentication. Otherwise, it logs an error message.
    * - Fixme: ⚠️️ add LAPolacy as param
    * - Parameters:
    *   - context: The LAContext instance used for performing biometric authentication
    *   - completion: A closure that is called when authentication completes, with a Result indicating success or failure
    */
   fileprivate func canEval(context: LAContext, completion: /*@escaping */OnComplete?) {
//      Swift.print("canEval")
      var error: NSError?
      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
         performEval(context: context, completion: completion)
      } else {
         print(error?.localizedDescription ?? "Cannot evaluate policy")
      }
   }
   // suggested by o1 ⚠️️
   // fixme: prefer using this instead
   // Handle LAContext Lifecycle Appropriately
   // It's important to manage the lifecycle of LAContext correctly to prevent unexpected behavior.
   // Suggestion: Invalidate the context upon failed authentication attempts or when it's no longer needed.
   fileprivate func performEval2(context: LAContext, completion: OnComplete?) {
         context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
               if success {
                     completion?(.success(true))
               } else {
                     context.invalidate() // Invalidate the context on failure
                     if let err = error as? LAError {
                        completion?(.failure(err))
                     }
               }
            }
         }
   }
   /**
    * Performs biometric authentication evaluation using the provided context
    * - Description: This function initiates the actual biometric authentication process using the LAContext.
    *                It displays a prompt to the user requesting biometric verification and handles the result
    *                through a completion handler. The function processes various authentication outcomes,
    *                including success and different types of failures (e.g., user cancellation, system errors).
    * - Fixme: ⚠️️ add LAPolacy as param
    * - Parameters:
    *   - context: The LAContext instance used to perform the biometric authentication evaluation
    *   - completion: A closure that is called when authentication completes, with a Result indicating success or failure
    */
   fileprivate func performEval(context: LAContext, completion: /*@escaping */OnComplete?) {
//      Swift.print("performEval")
      let reason: String = "Scan your face to log in."
      //DispatchQueue.main.async {
      //}
//       Task.detached { @MainActor in // main async? (eval policy is async)
//          Swift.print("eval policy")
          context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
             DispatchQueue.main.async { // this has to be here or else completion crashes
                if success {
                   completion?(.success(true))
                } else if let err = error as? LAError {
                   switch err.code {
                   case .authenticationFailed:
                      completion?(.failure(err))
                      // The user failed to provide valid credentials.
                   case .userCancel:
                      completion?(.failure(err))
                      // The user tapped the cancel button in the authentication dialog.
                   case .userFallback:
                      completion?(.failure(err))
                      // The user tapped the fallback button in the authentication dialog, but no fallback is available for the authentication policy.
                   case .systemCancel:
                      completion?(.failure(err))
                      // The system canceled authentication.
                   case .passcodeNotSet:
                      completion?(.failure(err))
                      // A passcode isn’t set on the device.
                   case .biometryNotAvailable:
                      completion?(.failure(err))
                      // Biometry is not available on the device.
                   case .biometryNotPaired:
                      completion?(.failure(err))
                      // The device supports biometry only using a removable accessory, but no accessory is paired.
                   case .biometryDisconnected:
                      // The device supports biometry only using a removable accessory, but the paired accessory isn’t connected.
                      completion?(.failure(err))
                   case .biometryLockout:
                      completion?(.failure(err))
                      // Biometry is locked because there were too many failed attempts.
                   case .biometryNotEnrolled:
                      // The user has no enrolled biometric identities.
                      completion?(.failure(err))
                   case .appCancel:
                      // The app canceled authentication.
                      completion?(.failure(err))
                   case .invalidContext:
                      // The context was previously invalidated.
                      completion?(.failure(err))
                   case .notInteractive:
                      // Displaying the required authentication user interface is forbidden.
                      completion?(.failure(err))
                     #if os(macOS)
                   case .watchNotAvailable:
                      // An attempt to authenticate with Apple Watch failed.
                      completion?(.failure(err))
                      // case .touchIDNotAvailable,touchIDNotEnrolled,touchIDLockout:
                      // - Fixme: ⚠️️ : Apple shows those errors altaught they're de-precated in iOS 11
                     #endif
                   default:
                      completion?(.failure(err))
                   }
                }
             }
          }
//       }
   }
}
