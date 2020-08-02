![](https://img.shields.io/github/license/srea/RIBsTreeViewerClient.svg) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# RIBsTreeViewer

![](./docs/logo.png)  

Real Time viewing attached RIBs Tree on Browser

## Demo

![](./docs/demo.gif)  

## Carthage

### Cartfile

```shell
github "srea/RIBsTreeViewerClient"
```

### Build Phase

![](./docs/Carthage_BuildPhase.png)  
![](./docs/Carthage_Embedded.png)

Carthage CopyFrameworks (ONLY DEBUG)

```shell
 if [ ${CONFIGURATION%%-*} == "Debug" ]; then
    /usr/local/bin/carthage copy-frameworks
 fi
```

### Implementation

```swift
// MARK: - RIBsTreeViewer

#if DEBUG
import RIBsTreeViewerClient

@available(iOS 13.0, *)
var RIBsTreeViewerHolder: RIBsTreeViewer? = nil

extension AppDelegate {
    private func startRIBsTreeViewer(launchRouter: Routing) {
        if #available(iOS 13.0, *) {
            RIBsTreeViewerHolder = RIBsTreeViewerImpl.init(router: launchRouter,
                                                           option: [.webSocketURL: "ws://0.0.0.0:8080",
                                                                    .monitoringInterval: 1000]])
            RIBsTreeViewerHolder?.start()
        } else {
            DEBUGLOG { "RIBsTreeViewer is not supported OS version." }
        }
    }
}
#endif
```

## WebSocket Server

```shell
$ yarn install
$ node index.js
```

## Browser

```shell
$ yarn install
$ npx webpack
$ open ./public/index.html
```
