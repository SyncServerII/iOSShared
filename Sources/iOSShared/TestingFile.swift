// Read a setup file during testing.

import Foundation

public struct TestingFile {
    // A bit of a hack from
    // https://stackoverflow.com/questions/47177036
    // but it seems portable across command line tests and Xcode tests.
    //
    public static func directoryOfFile(_ path: String = #file) -> URL {
        let thisSourceFile = URL(fileURLWithPath: path)
        return thisSourceFile.deletingLastPathComponent()
    }
}
