
import Foundation

// From http://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized

open class Synchronized {
    open class func block(_ lock: AnyObject, closure: () throws -> ()) rethrows {
        objc_sync_enter(lock)
        try closure()
        objc_sync_exit(lock)
    }
}
