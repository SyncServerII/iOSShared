
import Foundation

extension UUID {
    enum UUIDError: Error {
        case badUUIDString
    }
    
    public static func from(_ string: String?) throws -> UUID? {
        if let string = string {
            guard let uuid = UUID(uuidString: string) else {
                logger.error("badUUIDString: \(string)")
                throw UUIDError.badUUIDString
            }
            return uuid
        }
        return nil
    }
}
