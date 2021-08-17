if [[ $(pgrep -f "index.js") ]]; then
  kill -9 $(pgrep -f "index.js")
fi

DIR=$(pwd)

cd $DIR/../RIBsTreeViewer/Browser
open ./public/index.html

cd $DIR/../RIBsTreeViewer/WebSocketServer
node index.js