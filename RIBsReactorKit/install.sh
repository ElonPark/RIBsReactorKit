#!/usr/bin/env bash

brew bundle

carthage bootstrap --platform iOS --no-build

(cd Carthage/Checkouts/WeakMapTable && swift package generate-xcodeproj)
(cd Carthage/Checkouts/ReactorKit && swift package generate-xcodeproj)

carthage build --platform iOS
carthage update --platform iOS --no-use-binaries

if which yarn >/dev/null; then
  cd RIBsTreeViewer/Browser
  npx yarn install
  npx webpack
  open ./public/index.html

  cd ../WebSocketServer
  npx yarn install
  node index.js
else
  echo "warning: yarn not installed, try 'brew install yarn'"
fi
