
import Foundation

// User Alert Messages are intended to be informational; most not require a decision on the part of the user. They can be positive (e.g., "A user was created." or negative (e.g. "A server request failed.").

public enum UserAlertContents {
    // Only OK button
    case titleOnly(String)
    case titleAndMessage(title: String, message: String)
    
    // Shows "Error" as title
    case error(message: String)
    
    // With custom action button-- "Cancel" is also given.
    case customAction(title: String, message: String, actionButtonTitle:String, action:()->())
    
    case customDetailedAction(title: String, message: String, actionButtonTitle:String, action:()->(), cancelTitle: String, cancelAction:()->())
}

public protocol UserAlertDelegate: AnyObject {
    var userAlert: UserAlertContents? { get set }
}
