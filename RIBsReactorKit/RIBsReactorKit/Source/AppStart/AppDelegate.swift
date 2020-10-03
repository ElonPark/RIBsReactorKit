//
//  AppDelegate.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/15.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import EPLogger
import RIBs

/// import once and use it globally
public typealias Log = EPLogger.Log

@UIApplicationMain
final class AppDelegate:
  UIResponder,
  UIApplicationDelegate
{
  
  // MARK: - Properties
  
  var window: UIWindow?
  
  #if DEBUG
  private var ribsTreeViewer: RIBsTreeViewer?
  #endif
  
  // MARK: - Private
  
  private var launchRouter: LaunchRouting?
  
  // MARK: - UIApplicationDelegate
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let launchRouter = RootBuilder(dependency: AppComponent()).build()
    self.launchRouter = launchRouter
    launchRouter.launch(from: window)
    
    #if DEBUG
    startRIBsTreeViewer(launchRouter: launchRouter)
    #endif
    
    return true
  }
}

// MARK: - RIBsTreeViewer
#if DEBUG
import RIBsTreeViewerClient

extension AppDelegate {
  private func startRIBsTreeViewer(launchRouter: Routing) {
    guard ProcessInfo.processInfo.environment["UseRIBsTreeViewer"] != nil else { return }
    guard #available(iOS 13.0, *) else { return }
    ribsTreeViewer = RIBsTreeViewerImpl(
      router: launchRouter,
      options: [
        .webSocketURL("ws://0.0.0.0:8080"),
        .monitoringIntervalMillis(1000)
      ]
    )
    ribsTreeViewer?.start()
  }
}
#endif
