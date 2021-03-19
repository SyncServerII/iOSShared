//
//  iOSSharedBackgroundTask.swift
//  iOSSharedTests
//
//  Created by Christopher G Prince on 3/18/21.
//

import XCTest
@testable import iOSShared

class iOSSharedBackgroundTask: XCTestCase {
    let mainAppBackgroundTask = MainAppBackgroundTask()
    let extensionBackgroundTask = ExtensionBackgroundTask()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainAppBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = mainAppBackgroundTask
        
        var result: URL?
        result = try? backgroundAsssertable.run { ()->(URL?) in
            let docsURL = Files.getDocumentsDirectory()
            do {
                return try Files.createTemporary(withPrefix: "SyncServer", andExtension: "dat", inDirectory: docsURL)
            } catch let error {
                XCTFail("\(error)")
            }
            return nil
        } expiry: {
            XCTFail()
        }
        
        XCTAssert(result != nil)
    }
    
   func testExtensionBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = extensionBackgroundTask
        
        var result: URL?
        result = try? backgroundAsssertable.run { ()->(URL?) in
            let docsURL = Files.getDocumentsDirectory()
            do {
                return try Files.createTemporary(withPrefix: "SyncServer", andExtension: "dat", inDirectory: docsURL)
            } catch let error {
                XCTFail("\(error)")
            }
            return nil
        } expiry: {
            XCTFail()
        }
        
        XCTAssert(result != nil)
    }
}
