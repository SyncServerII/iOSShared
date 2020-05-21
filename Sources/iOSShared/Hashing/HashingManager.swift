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
    
    public func hashFor(url: URL, accountName: String) throws -> String {
        let filter = current.filter { $0.accountName == accountName }
        guard filter.count == 1 else {
            throw HashingManagerError.noHasher
        }
        
        return try filter[0].hash(forURL: url)
    }
}
