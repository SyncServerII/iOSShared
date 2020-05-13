import UIKit

public extension UIView {
    func centerVerticallyInSuperview() {
        guard let superview = superview else {
            return
        }
        
        let superCenterY = superview.frame.height/2.0
        var selfCenter = center
        selfCenter.y = superCenterY
        center = selfCenter
    }
}
