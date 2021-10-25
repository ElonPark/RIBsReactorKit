[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FElonPark%2FRIBsReactorKit&count_bg=%235890E1&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

# RIBsReactorKit

[RIBs](https://github.com/uber/RIBs) X [ReactorKit](https://github.com/ReactorKit/ReactorKit) PoC

<img src="./Docs/RIBsReactorKit.png" alt="RIBsReactorKit" width="500" />

### Related post
- [medium](https://blog.mathpresso.com/ribs에-reactorkit-도입하기-6593124a34ec)

### install

Required Xcode 12.5 or above
```shell
$ sh install.sh
```

---
## Use RIBsTreeViewer

### Installing 

```
$ npm install yarn
```

### Starting the websocket server

```shell
$ cd ./RIBsTreeViewer/WebSocketServer
$ npx yarn install
$ node index.js
```

## Open the page.

```shell
$ cd ./RIBsTreeViewer/Browser
$ npx yarn install
$ npx webpack
$ open ./public/index.html
```


