
import Foundation

// User Alert Messages are intended to be informational, and not require a decision on the part of the user. They can be positive (e.g., "A user was created." or negative (e.g. "A server request failed.").

public enum UserAlertContents {
    case title(String)
    case full(title: String, message: String)
    
    // Shows "Error" as title
    case error(message: String)
}

public protocol UserAlertDelegate: AnyObject {
    var userAlert: UserAlertContents? { get set }
}
