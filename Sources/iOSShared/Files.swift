import Foundation

public struct Files {
    enum FilesError: Error {
        case directoryWasAFile
        case itemDidNotExist
        case couldNotCreateFile
    }
    
    // Creates a temporary file within the given directory. If the URL returned, the file will have been created, and zero length upon return. Uses a UUID to form the file name and assumes there will be no collision.
    // If create is false, doesn't actually create the file. But makes sure the file doesn't already exist.
    public static func createTemporary(withPrefix prefix: String, andExtension extension: String, inDirectory directory: URL, create: Bool = true) throws -> URL {
        var directory = directory
        try createDirectoryIfNeeded(directory)
        
        // Don't let these temporary files be backed up to iCloud-- Apple doesn't like this (e.g., when reviewing apps).
        
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try directory.setResourceValues(resourceValues)
        
        let uuid = UUID().uuidString
        let fileName = "\(prefix).\(uuid).\(`extension`)"
        
        let newFileURL = directory.appendingPathComponent(fileName)
        
        if create {
            guard FileManager.default.createFile(atPath: newFileURL.path, contents: nil, attributes: nil) else {
                throw FilesError.couldNotCreateFile
            }
        }
        else {
            guard !FileManager.default.fileExists(atPath: newFileURL.path) else {
                throw FilesError.couldNotCreateFile
            }
        }
        
        return newFileURL
    }
    
    public static func createDirectoryIfNeeded(_ directory: URL) throws {
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: directory.path, isDirectory:&isDir) {
            if !isDir.boolValue {
                throw FilesError.directoryWasAFile
            }
        } else {
            // Create the directory.
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public static func getDocumentsDirectory() -> URL {
        if let documentsURL = SharedContainer.session?.documentsURL {
            return documentsURL
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Throws an error if there is no item at the URL
    public static func isDirectory(_ url: URL) throws -> Bool {
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory:&isDir) {
            if isDir.boolValue {
                return true
            }
        }
        else {
            throw FilesError.itemDidNotExist
        }
        
        return false
    }
    
    public static func isFile(_ url: URL) throws -> Bool {
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory:&isDir) {
            if !isDir.boolValue {
                return true
            }
        }
        else {
            throw FilesError.itemDidNotExist
        }
        
        return false
    }
}
