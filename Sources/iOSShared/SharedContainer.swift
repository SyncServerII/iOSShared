import Foundation

// See https://developer.apple.com/documentation/foundation/filemanager/1412643-containerurl
// "The system creates only the Library/Caches subdirectory automatically,..."
// (So no Documents directory for free).

public struct SharedContainer {
    // "Fake" documents directory
    let documents = "Documents"
    public let documentsURL: URL
    
    enum SharedContainerError: Error {
        case badContainerURL
    }
    
    let applicationGroupIdentifier: String
    public let sharedContainerURL: URL
    
    // If you want to use this, you must set the session value. Set this when your app launches, with `appLaunchSetup`.
    public static var session:SharedContainer?
    
    init(applicationGroupIdentifier: String) throws {
        self.applicationGroupIdentifier = applicationGroupIdentifier
        
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier) else {
            throw SharedContainerError.badContainerURL
        }
        
        sharedContainerURL = url
        
        documentsURL = sharedContainerURL.appendingPathComponent(documents)
        try Files.createDirectoryIfNeeded(documentsURL)
    }
    
    // You must use the App Groups Entitlement and setup a applicationGroupIdentifier https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups
    // Identifier formatted as: group.<group name>
    public static func appLaunchSetup(applicationGroupIdentifier: String) throws {
        session = try SharedContainer(applicationGroupIdentifier: applicationGroupIdentifier)
    }
}
