# RIBsReactorKit
RIBs + ReactorKit Sample

[RIBs](https://github.com/uber/RIBs)에 [ReactorKit](https://github.com/ReactorKit/ReactorKit) 조합하여 사용하기 위한 샘플

### install

```shell
$ sh install.sh
```

---
## RIBsTreeViewer

### Installing 

```
$ npm install yarn
```

### Starting the websocke server

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