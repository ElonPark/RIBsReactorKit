#!/usr/bin/env bash

# Delete existing file

rm -r ./Products/RIBsTreeViewerClient.xcframework

# Generate RIBsTreeViewerClient

xcodebuild \
'ENABLE_BITCODE=YES' \
'BITCODE_GENERATION_MODE=bitcode' \
'OTHER_CFLAGS=-fembed-bitcode' \
'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
'SKIP_INSTALL=NO' \
archive \
-project RIBsTreeViewerClient.xcodeproj \
-scheme 'RIBsTreeViewerClient' \
-destination 'generic/platform=iOS Simulator' \
-configuration 'Release' \
-archivePath 'build/RIBsTreeViewerClient-iOS-Simulator.xcarchive'


xcodebuild \
'ENABLE_BITCODE=YES' \
'BITCODE_GENERATION_MODE=bitcode' \
'OTHER_CFLAGS=-fembed-bitcode' \
'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
'SKIP_INSTALL=NO' \
archive \
-project RIBsTreeViewerClient.xcodeproj \
-scheme 'RIBsTreeViewerClient' \
-destination 'generic/platform=iOS' \
-configuration 'Release' \
-archivePath 'build/RIBsTreeViewerClient-iOS.xcarchive'


xcodebuild \
-create-xcframework \
-framework 'build/RIBsTreeViewerClient-iOS-Simulator.xcarchive/Products/Library/Frameworks/RIBsTreeViewerClient.framework' \
-framework 'build/RIBsTreeViewerClient-iOS.xcarchive/Products/Library/Frameworks/RIBsTreeViewerClient.framework' \
-output 'Products/RIBsTreeViewerClient.xcframework'