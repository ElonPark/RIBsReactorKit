#!/usr/bin/env bash

brew bundle

carthage bootstrap --platform iOS --no-build

(cd Carthage/Checkouts/WeakMapTable && swift package generate-xcodeproj)
(cd Carthage/Checkouts/ReactorKit && swift package generate-xcodeproj)

carthage build --platform iOS
