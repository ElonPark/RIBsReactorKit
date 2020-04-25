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
class AppDelegate:
  UIResponder,
  UIApplicationDelegate
{
  
  // MARK: - Properties
  
  var window: UIWindow?
  
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
    
    return true
  }
}
