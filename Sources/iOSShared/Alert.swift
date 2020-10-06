import UIKit

public struct Alert {
    public static func show(fromVC: UIViewController? = nil, withTitle title:String? = nil, message:String? = nil, allowCancel cancel:Bool = false, style: UIAlertController.Style = .actionSheet, okCompletion:(()->())? = nil) {
    
        var vc: UIViewController? = fromVC
        if vc == nil {
            vc = UIApplication.shared.delegate?.window??.rootViewController
            
            // 9/27/20-- I get a nil vc above with SwiftUI. Trying:
            // https://stackoverflow.com/questions/58548569
            if vc == nil {
                 vc = UIApplication.shared.windows.first?.rootViewController
            }
        }
        
        guard let vcToUse = vc else {
            logger.error("Failed to get view controller for Alert!")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.popoverPresentationController?.sourceView = vcToUse.view
    
        alert.addAction(UIAlertAction(title: "OK", style: .default) { alert in
            okCompletion?()
        })
        
        if cancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { alert in
            })
        }
        
        vcToUse.present(alert, animated: true, completion: nil)
    }
}
