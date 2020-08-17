rm -rf ~/Library/Developer/Xcode/DerivedData/*
xcodebuild -scheme RIBsReactorKit > xcodebuild.log
swiftlint analyze --compiler-log-path xcodebuild.log > result.html
open result.html
rm xcodebuild.log