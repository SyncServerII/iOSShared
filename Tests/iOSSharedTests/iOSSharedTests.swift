import XCTest
@testable import iOSShared
import iOSServerShared

final class iOSSharedTests: XCTestCase {
    func testTestingFile() throws {
        let thisDirectory = TestingFile.directoryOfFile(#file)
        let dropboxCredentials = thisDirectory.appendingPathComponent("Dropbox.credentials")
        _ = try Data(contentsOf: dropboxCredentials)
    }
    
    func testCreateDirectoryIfNeeded() throws {
        var docsURL = Files.getDocumentsDirectory()
        let uuid = UUID().uuidString
        docsURL.appendPathComponent(uuid)
        try Files.createDirectoryIfNeeded(docsURL)
        
        XCTAssert(try Files.isDirectory(docsURL))
    }
    
    func testCreateTemporary() throws {
        let docsURL = Files.getDocumentsDirectory()
        let result = try Files.createTemporary(withPrefix: "SyncServer", andExtension: "dat", inDirectory: docsURL)
        XCTAssert(try Files.isFile(result))
    }
    
    struct Hasher: CloudStorageHashing {
        var cloudStorageType: CloudStorageType = .Dropbox
        func hash(forURL url: URL) throws -> String {
            return "stuff"
        }
        
        func hash(forData data: Data) throws -> String {
            return "other stuff"
        }
    }
    
    func testAddHashingManager() throws {
        let manager = HashingManager()
        try manager.add(hashing: Hasher())
    }
    
    func testAddHashingManagerTwiceFails() throws {
        let manager = HashingManager()
        try manager.add(hashing: Hasher())
        
        do {
            try manager.add(hashing: Hasher())
        } catch {
            return
        }
        
        XCTFail()
    }
    
    func testHashForKnownHasherWorks() throws {
        let manager = HashingManager()
        try manager.add(hashing: Hasher())
        let url = URL(fileURLWithPath: "foobly")
        let hasher = try manager.hashFor(cloudStorageType: .Dropbox)
        let _ = try hasher.hash(forURL: url)
    }
    
    func testHashForUnknownHasherFails() throws {
        let manager = HashingManager()
        try manager.add(hashing: Hasher())
        
        do {
            let _ = try manager.hashFor(cloudStorageType: .Google)
        } catch {
            return
        }
        
        XCTFail()
    }
}
