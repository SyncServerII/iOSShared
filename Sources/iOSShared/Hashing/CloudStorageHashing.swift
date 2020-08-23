import Foundation
import iOSServerShared

// Every cloud storage type (e.g., Dropbox, Google) has to implement this protocol
public protocol CloudStorageHashing {
    var cloudStorageType:CloudStorageType { get }
    
    func hash(forURL url: URL) throws -> String
    func hash(forData data: Data) throws -> String
}
