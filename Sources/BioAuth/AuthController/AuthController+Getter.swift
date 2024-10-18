import Foundation
import LocalAuthentication
/**
 * Getter
 */
extension AuthController {
   /**
    * Allows context to be lazy loaded if requested and to be nil if needed
    * - Abstract: Provides a lazy-loaded context that can be optionally set or reset.
    * - Description: The `context` property provides access to an `LAContext`
    *                instance which is used for managing biometric authentication.
    *                It is lazy-loaded, meaning that it is only created when it
    *                is first accessed. If the `_context` instance variable is
    *                already set, it returns that instance; otherwise, it
    *                creates a new `LAContext`, assigns it to `_context`, and
    *                then returns it. This property can also be set to nil,
    *                allowing the context to be reset if necessary.
    * - Note: Alt name: `authContext`
    */
   public var context: LAContext? {
      get {
         if let context = _context { // Check if the context exists
            return context // Return the existing context
         } else {
            let context = LAContext() // Create a new context
            _context = context // Set the new context as the existing context
            return context // Return the new context
         }
      } set {
         _context = newValue // Set the new value as the context
      }
   }
}
