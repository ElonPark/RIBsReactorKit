//
//  AppDelegate.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/15.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import EPLogger
import Reachability
import RIBs

/// import once and use it globally
public typealias Log = EPLogger.Log

// MARK: - AppDelegate

@UIApplicationMain
final class AppDelegate:
  UIResponder,
  UIApplicationDelegate
{

  // MARK: - Properties

  var window: UIWindow?

  private var launchRouter: LaunchRouting?
  private var reachability: Reachability?

  // MARK: - UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerProviderFactories()

    setReachability()

    setWindow()
    setLaunchRouter()

    return true
  }
}

// MARK: - Private methods

extension AppDelegate {
  private func setWindow() {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
  }

  private func setLaunchRouter() {
    guard let window = self.window else { return }
    let appComponent = AppComponent()
    self.launchRouter = appComponent.rootBuilder.build()
    self.launchRouter?.launch(from: window)
  }

  private func setReachability() {
    do {
      self.reachability = try Reachability()
      try self.reachability?.startNotifier()
    } catch {
      Log.error(error)
    }
  }
}
