import Foundation
import LocalAuthentication
/**
 * Returns the name of biometric authentication method
 * - Description: Enumerates the types of biometric authentication methods
 *                available on a device, such as Touch ID or Face ID, or
 *                indicates that no biometric support is present.
 * - Remark: There is also: `LABiometryType`
 */
public enum BioAuthType: String {
   /**
    * Device supports Touch ID
    */
   case touch = "Touch ID"
   /**
    * Device has no biometric support
    */
   case face = "Face ID"
   /**
    * Device support Face ID
    */
   case none = "BioAuth not supported"
}
/**
 * Getter
 */
extension BioAuthType {
   /**
    * Returns the supported `BioAuthType` for the device (touch, face, none).
    * - Description: This property provides a convenient way to determine the
    *                type of biometric authentication supported by the current
    *                device, if any. It checks the accessibility of
    *                biometric authentication and then uses the `LAContext`
    *                class to determine the type of biometry available,
    *                returning a corresponding `BioAuthType` value.
    * - Throws: An error if biometric authentication is not accessible on the
    *           device.
    * - Remark: This method should be used instead of accessing the `type`
    *           property directly.
    * - Returns: The supported `BioAuthType` for the device.
    * - Fixme: ⚠️️ Make a method and add the error msg , and throw it
    * ## Examples:
    * BioAuthType.type // .face
    */
   public static var type: BioAuthType {
      // Check if biometric authentication is accessible on the device, return .none if not accessible
      guard BioAuth.isAccessible else { return .none }
      // Initialize a new context for evaluating the biometric authentication
      let authContext: LAContext = .init()
      // - Fixme: ⚠️️⚠️️ Not needed anymore, package support 11 and 10.13 and up only
      if #available(iOS 11, macOS 10.13.2, *) { // face-id support started from iOS 11 and mac 10.13.2
         switch authContext.biometryType {
         case .touchID: return .touch // If the biometric type is Touch ID, return .touch
         case .faceID: return .face // If the biometric type is Face ID, return .face
            /*@unknown */default: return .none // If the biometric type is not recognized, return .none
         }
      } else {
         return .touch
      }
   }
   /**
    * Get the title for biometric authentication
    * - Description: Retrieves the localized title for biometric authentication
    *                based on the device's support for biometric features. If
    *                the device supports modern biometric authentication
    *                (Face ID or Touch ID), the `normal` closure is executed
    *                with the corresponding title. For older devices without
    *                biometric support, the `old` closure is executed.
    * - Remark: The title is derived from CommonModel assets
    * - Remark: We may not need to support old devices anymore since we only
    *           support modern iOS and macOS versions
    * - Note: Alternative name: `getAttrAuthTitleAndDesc`
    * - Example: To get the title for biometric authentication, use
    *            `let authTitle = BioAuthType.getAuthTitle(normal: { type in
    *            return "Biometric type: \(type)" }, old: { _ in return
    *            "Biometric not supported" })`
    * - Parameters:
    *   - normal: The closure to execute if the device supports biometric authentication
    *   - old: The closure to execute if the device does not support biometric authentication
    */
   public static func getAuthTitle(normal: AuthTitleClosure, old: AuthTitleClosure) -> AuthTitle {
      if #available(iOS 8.0, macOS 10.12.1, *) {
         return normal(BioAuthType.type.rawValue) // Type can be face or touch
      } else {
         // - Fixme: ⚠️️ Add some kind of error message here
         return old("") // Device does not support biometric authentication
      }
   }
   /**
    * Returns the title and description of the biometric authentication prompt.
    * - Description: This method determines the appropriate title and
    *                description for the biometric authentication prompt based
    *                on the type of biometric feature available on the device.
    *                It uses closures to provide the title and description for
    *                either modern or older devices, ensuring compatibility and
    *                a tailored user experience.
    * - Returns: The title and description of the biometric authentication prompt.
    * - Remark: The title and description are derived from CommonModel assets.
    * - Remark: We may not need to support old devices anymore since we only support modern iOS and macOS versions.
    * - Fixme: ⚠️️ Add some kind of error message here for devices that do not support biometric authentication.
    * - Parameters:
    *   - normal: The closure for the title of the biometric authentication prompt.
    *   - old: The closure for the title of the biometric authentication prompt for older devices.
    */
   public static func getAttrAuthTitleAndDesc(normal: AttrAuthTitleClosure, old: AttrAuthTitleClosure) -> AttrAuthTitleAndDesc {
      if #available(iOS 8.0, macOS 10.12.1, *) {
         return normal(BioAuthType.type.rawValue) // Return the title and description for devices that support biometric authentication
      } else {
         return old("") // Return the title and description for devices that do not support biometric authentication
      }
   }
}
/**
 * Type
 */
extension BioAuthType {
   /**
    * Tuple type for the title and description of the biometric authentication prompt.
    * - Description: Represents the title and description used in the
    *                biometric authentication prompt, encapsulating the text
    *                that will be displayed to the user when biometric
    *                authentication is requested.
    * - Note: Alternative name: `AuthTitleAndDesc`
    * - Parameters:
    *   - title: The title of the biometric authentication prompt.
    *   - description: The description of the biometric authentication prompt.
    */
   public struct AuthTitle {
      /**
       * The title of the authentication prompt
       */
      let title: String
      /**
       * The description of the authentication prompt
       */
      let description: String
   }
   /**
    * Closure for the title of the biometric authentication prompt.
    * - Description: This closure is used to create an `AuthTitle` object,
    *                which contains the title and description for the
    *                biometric authentication prompt. The type of biometric
    *                authentication, such as face or touch, is passed as a
    *                parameter to customize the prompt accordingly.
    * - Parameter type: The type of biometric authentication (face or touch).
    * - Returns: The title of the biometric authentication prompt.
    * - Note: Alternative name: `AuthTitleAndDescClosure`
    */
   public typealias AuthTitleClosure = (String) -> AuthTitle
   /**
    * Tuple type for the title and description of the biometric authentication prompt as attributed strings.
    * - Description: This struct represents the title and description of the
    *                biometric authentication prompt, but with the text
    *                formatted as attributed strings. This allows for more
    *                complex styling of the text, such as different fonts,
    *                colors, or other attributes. The title and description
    *                are used in the biometric authentication prompt, providing
    *                the user with context for why authentication is being
    *                requested.
    * - Parameters:
    *   - title: The title of the biometric authentication prompt as an
    *            attributed string.
    *   - description: The description of the biometric authentication prompt as
    *                  an attributed string.
    */
   public struct AttrAuthTitleAndDesc {
      /**
       * The attributed string for the authentication prompt title
       */
      let title: NSAttributedString
      /**
       * The attributed string for the authentication prompt description
       */
      let description: NSAttributedString
   }
   /**
    * Closure for the title and description of the biometric authentication prompt
    * - Parameters:
    *   - title: The title of the biometric authentication prompt
    *   - description: The description of the biometric authentication prompt
    * - Returns: The title and description of the biometric authentication prompt
    */
   public typealias AttrAuthTitleClosure = (String) -> AttrAuthTitleAndDesc
}
