import Foundation
import UIKit

extension UIViewController {
    // Adapted from https://stackoverflow.com/questions/41073915/swift-3-how-to-get-the-current-displaying-uiviewcontroller-not-in-appdelegate
    public static func getTop() -> UIViewController? {

        var viewController:UIViewController?
        
        var rootViewController: UIViewController? {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        }

        if let vc = rootViewController {

            viewController = vc
            var presented = vc

            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }

        return viewController
    }
}
