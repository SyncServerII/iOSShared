import Foundation

public class HashingManager {
    enum HashingManagerError: Error {
        case noHasher
        case hasherAlreadyExists
    }
    
    private var current = [CloudStorageHashing]()
    
    init() {
    }
    
    public func add(hashing: CloudStorageHashing) throws {
        let filter = current.filter { $0.accountName == hashing.accountName }
        guard filter.count == 0 else {
            throw HashingManagerError.hasherAlreadyExists
        }
        
        current += [hashing]
    }
    
    public func hashFor(accountName: String) throws -> CloudStorageHashing {
        let filter = current.filter { $0.accountName == accountName }
        guard filter.count == 1 else {
            throw HashingManagerError.noHasher
        }
        
        return filter[0]
    }
}
