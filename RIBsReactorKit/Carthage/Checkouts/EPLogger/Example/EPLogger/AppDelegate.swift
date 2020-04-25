//
//  AppDelegate.swift
//  EPLogger
//
//  Created by elon on 08/29/2019.
//  Copyright (c) 2019 elon. All rights reserved.
//

import UIKit
import EPLogger

// If you want to get import once and use it globally
public typealias Log = EPLogger.Log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        // Set log level. default is verbose
        Log.congfig(level: .verbose, dateFormat: "HH:mm:ss.SSS")
        
        return true
    }
}

