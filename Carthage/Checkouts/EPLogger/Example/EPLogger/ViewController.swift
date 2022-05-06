//
//  ViewController.swift
//  EPLogger
//
//  Created by elon on 08/29/2019.
//  Copyright (c) 2019 elon. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.verbose("This is verbose")
        Log.debug("This is debug")
        Log.info("This is info")
        Log.warning("This is warning")
        Log.error("This is error")
        
        logItem()
        logItems()
        
        changeFormat()
        changeLogLevelHeader()
        changeSeparator()
    }
    
    private func logItem() {
        print("\n - item")
        
        let text = "Sample String!"
        Log.verbose(text)
        Log.verbose(printBy: .debug, text)
        Log.verbose(printBy: .dump, text)
        
        print("")
        
        let sample = SampleStruct()
        Log.debug(sample)
        Log.debug(printBy: .debug, sample)
        Log.debug(printBy: .dump, sample)
        
        print("")
        
        Log.verbose(StringEnum.normal)
        Log.verbose(printBy: .debug, StringEnum.vip)
        Log.verbose(printBy: .dump, StringEnum.vvip)
        
        print("")
        
        Log.debug(IntEnum.one)
        Log.debug(printBy: .debug, IntEnum.one)
        Log.debug(printBy: .dump, IntEnum.two)
    }
    
    private func logItems() {
        print("\n - items")
        
        let text = "Sample String2!"
        let sample = SampleStruct()
        Log.verbose(text, sample, StringEnum.vvip, IntEnum.two)
        Log.verbose(printBy: .debug, text, sample, StringEnum.vvip, IntEnum.two)
        Log.verbose(printBy: .dump, text, sample, StringEnum.vvip, IntEnum.two)
    }
    
    private func changeFormat() {
        print("\n - change format")
        Log.config(formatType: .short)
        Log.verbose("short")
        
        Log.config(formatType: .medium)
        Log.debug("medium")
        
        Log.config(formatType: .long)
        Log.info("long")
        
        Log.config(formatType: .full)
        Log.warning("full")
    }
    
    private func changeLogLevelHeader() {
        Log.config(formatType: .short)
        print("\n - change log level header")
        Log.config(customLevelHeader: [
            .verbose: "VERBOSE",
            .debug: "DEBUG"
        ])
        Log.verbose("This is verbose")
        Log.debug("This is debug")
        Log.info("This is info")
        Log.warning("This is warning")
        Log.error("This is error")
    }
    
    private func changeSeparator() {
        print("\n - change separator")
        Log.config(separator: ": ")
        Log.info("Hello")
        Log.warning("world!")
        print("")
        
        Log.config(
            level: .debug,
            formatType: .medium,
            separator: " -> "
        )
        Log.verbose("This is verbose")
        Log.debug("This is debug")
        Log.info("This is info")
        Log.warning("This is warning")
        Log.error("This is error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        Log.warning("Memory Warning!")
    }
}

