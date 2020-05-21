import Foundation

// Every cloud storage type (e.g., Dropbox, Google) has to implement this protocol
public protocol CloudStorageHashing {
    // E.g., "Dropbox"
    var accountName:String { get }
    
    func hash(forURL url: URL) throws -> String
    func hash(forData data: Data) throws -> String
}
