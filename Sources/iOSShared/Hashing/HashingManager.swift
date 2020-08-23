import Foundation
import ServerShared

public class HashingManager {
    enum HashingManagerError: Error {
        case noHasher
        case hasherAlreadyExists
    }
    
    private var current = [CloudStorageHashing]()
    
    public init() {
    }
    
    public func add(hashing: CloudStorageHashing) throws {
        let filter = current.filter { $0.cloudStorageType == hashing.cloudStorageType }
        guard filter.count == 0 else {
            throw HashingManagerError.hasherAlreadyExists
        }
        
        current += [hashing]
    }
    
    public func hashFor(cloudStorageType: CloudStorageType) throws -> CloudStorageHashing {
        let filter = current.filter { $0.cloudStorageType == cloudStorageType }
        guard filter.count == 1 else {
            throw HashingManagerError.noHasher
        }
        
        return filter[0]
    }
}
