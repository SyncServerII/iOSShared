//
//  File.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI

public enum AlertyHelper {
    public static func customAction(title: String, message: String, actionButtonTitle: String, action: @escaping ()->(), cancelTitle: String, cancelAction: (()->())? = nil) -> SwiftUI.Alert {
        let cancel = SwiftUI.Alert.Button.cancel(Text(cancelTitle)) {
            cancelAction?()
        }
        let defaultButton = SwiftUI.Alert.Button.default(
            Text(actionButtonTitle),
            action: {
                action()
            }
        )
        return SwiftUI.Alert(title: Text(title), message: Text(message), primaryButton: defaultButton, secondaryButton: cancel)
    }
    
    public static func error(message: String) -> SwiftUI.Alert {
        return SwiftUI.Alert(title: Text("Error!"), message: Text(message))
    }
    
    public static func alert(title: String, message: String) -> SwiftUI.Alert {
        return SwiftUI.Alert(title: Text(title), message: Text(message))
    }
}
