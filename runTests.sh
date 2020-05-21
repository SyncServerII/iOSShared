#!/bin/bash

# Just running "swift test" causes failures, not finding UIKit, so I'm using xcodebuild test.

xcodebuild test -scheme iOSShared -destination 'platform=iOS Simulator,name=iPhone 8,OS=13.4.1'