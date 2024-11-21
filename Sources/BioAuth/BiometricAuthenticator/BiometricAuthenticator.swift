import LocalAuthentication
// very basic but works
public class BiometricAuthenticator {
   public static let shared = BiometricAuthenticator()
   private let context = LAContext()
   
   private init() {}
   
   public func authenticate(reason: String, completion: @escaping (Bool, Error?) -> Void) {
      var error: NSError?
      
      guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
         completion(false, error)
         return
      }
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
         DispatchQueue.main.async {
            completion(success, error)
         }
      }
   }
}
