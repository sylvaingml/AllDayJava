#!/bin/bash

# You may need to change destination to match your own setup
xcodebuild -project AllDayJava.xcodeproj -scheme AllDayJava -destination 'platform=iOS Simulator,name=iPhone 6' clean build test

