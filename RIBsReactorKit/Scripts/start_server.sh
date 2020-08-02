if [[ $(pgrep -f "viewer.js") ]]; then
  kill -9 $(pgrep -f "viewer.js")
fi

DIR=$(pwd)

cd $DIR/../RIBsTreeViewer/Browser
open ./public/index.html

cd $DIR/../RIBsTreeViewer/WebSocketServer
node viewer.js