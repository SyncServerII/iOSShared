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

    func testSyncMainAppBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = mainAppBackgroundTask
        
        var result: URL?
        result = try? backgroundAsssertable.syncRun { ()->(URL?) in
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
    
    func testAsyncMainAppBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = mainAppBackgroundTask
        
        let exp = expectation(description: "exp")
        
        backgroundAsssertable.asyncRun { completion in
            let docsURL = Files.getDocumentsDirectory()
            do {
                _ = try Files.createTemporary(withPrefix: "SyncServer", andExtension: "dat", inDirectory: docsURL)
            } catch let error {
                XCTFail("\(error)")
            }
            
            completion()
            exp.fulfill()
        } expiry: {
            XCTFail()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSyncExtensionBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = extensionBackgroundTask
        
        var result: URL?
        result = try? backgroundAsssertable.syncRun { ()->(URL?) in
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
    
    func testAsyncExtensionBackgroundTask() throws {
        let backgroundAsssertable: BackgroundAsssertable = extensionBackgroundTask
        
        let exp = expectation(description: "exp")
        
        backgroundAsssertable.asyncRun { completion in
            let docsURL = Files.getDocumentsDirectory()
            do {
                _ = try Files.createTemporary(withPrefix: "SyncServer", andExtension: "dat", inDirectory: docsURL)
            } catch let error {
                XCTFail("\(error)")
            }
            
            completion()
            exp.fulfill()
        } expiry: {
            XCTFail()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
