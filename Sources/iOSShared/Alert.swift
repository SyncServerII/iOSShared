import UIKit

public struct Alert {
    public static func show(fromVC: UIViewController? = nil, withTitle title:String? = nil, message:String? = nil, allowCancel cancel:Bool = false, okCompletion:(()->())? = nil) {
    
        var vc: UIViewController? = fromVC
        if vc == nil {
            let window:UIWindow = (UIApplication.shared.delegate?.window)!!
            vc = window.rootViewController
        }
        
        guard let vcToUse = vc else {
            logger.error("Failed to get view controller for Alert!")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
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
