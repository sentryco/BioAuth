import SwiftUI
import BioAuth
/**
 * - Description: App for macOS and iOS
 */
@main
struct ExampleAppApp: App {
   @State private var showAlert = false
   @State private var alertMessage = ""
   @State private var alertTitle = ""
   /**
    * - Important: ⚠️️ This xcodeproj uses
    */
    var body: some Scene {
        WindowGroup {
           EmptyView()
              .onAppear {
                 // Initialize BioAuth and handle the result using the `Result` type
                 // BioAuth.initBioAuth(complete: handleBioAuthResult)
                 AuthController.shared.permitAndAuth { success in
                    Swift.print("success:  \(success ? "✅" : "🚫")")
                 }
//                 BiometricAuthenticator.shared.authenticate(reason: "Authenticate to access the app") { success, error in
//                    if success {
//                       print("Authentication successful")
//                    } else {
//                       print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
//                    }
//                 }
              }
              .alert(isPresented: $showAlert) { // Add alert
                 Alert(
                  title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"))
                 )
              }
        }
    }
}
extension ExampleAppApp {
   /**
    * Handles the result of the biometric authentication process.
    * - Parameter result: The result of the biometric authentication, which can be either a success with a description or a failure with an error.
    */
   func handleBioAuthResult(result: BioAuth.ResultType) {
      switch result { // Trigger the alert
      case .success(let desc):
         self.notifyUser(desc.msg, err: nil) // If the result is successful, notify the user with the description
         Swift.print("Success ✅")
      case .failure(let error):
         self.notifyUser("Error", err: error.localizedDescription) // If the result is a failure, notify the user with the error message
         Swift.print("Error: 🚫")
      }
   }
   /**
    * Define a function to notify the user with an alert
    */
   func notifyUser(_ msg: String, err: String? = nil) {
      self.alertTitle = msg
      self.alertMessage = err ?? "No error"
      self.showAlert = true
   }
}
