
import Foundation
import SwiftUI

// User Alert Messages are intended to be informational, and not require a decision on the part of the user. They can be positive (e.g., "A user was created." or negative (e.g. "A server request failed.").

public enum UserAlertContents {
    case title(String)
    case full(title: String, message: String)
    
    // Shows "Error" as title
    case error(message: String)
}

public protocol UserAlertMessage: AnyObject {
    var userAlert: UserAlertContents? { get set }
    var screenDisplayed: Bool { get set }
}

public class UserAlertModel: ObservableObject, UserAlertMessage {
    public var screenDisplayed: Bool = false
    @Published public var show: Bool = false
    
    public var userAlert: UserAlertContents? {
        didSet {
            // If we don't constrain this by whether or not the screen is displayed, when we navigate to other screens, we get the same error, once per screen-- because each screen model has an `errorSubscription`. I don't know if having these models remain allocated is standard behavior for SwiftUI, but currently it is the case.
            show = userAlert != nil && screenDisplayed
        }
    }
    
    public init() {}
}
