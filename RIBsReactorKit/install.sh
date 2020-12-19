#!/usr/bin/env bash

brew bundle

carthage bootstrap --platform iOS --new-resolver --no-use-binaries --cache-builds

rm -rf ./Carthage/Checkouts/ReactiveSwift
rm -rf ./Carthage/Build/iOS/ReactiveSwift.*
rm -rf ./Carthage/Build/iOS/ReactiveMoya.*

if which yarn >/dev/null; then
  (cd ./RIBsTreeViewer/Browser && npx yarn install)
  (cd ./RIBsTreeViewer/Browser && npx webpack)
  (cd ./RIBsTreeViewer/WebSocketServer && npx yarn install)
else
  echo "warning: yarn not installed, try 'brew install yarn'"
fi