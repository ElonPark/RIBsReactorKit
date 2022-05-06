#!/usr/bin/env bash

if which yarn >/dev/null; then
  (cd ../RIBsTreeViewer/Browser && npx yarn install && npx webpack)
  (cd ../RIBsTreeViewer/WebSocketServer && npx yarn install)
else
  echo "warning: yarn not installed, try 'brew install yarn'"
fi