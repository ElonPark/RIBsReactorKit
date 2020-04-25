//
//  EPLogger.swift
//  EPLogger
//
//  Created by Elon on 29/08/2019.
//

import Foundation

fileprivate extension DispatchQueue {
    static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
extension Log {
    public enum PrinterType {
        /// use `print()`
        case `default`
        
        /// use `debugPrint()`
        case debug
        
        /// use `dump()`
        case dump
    }
}

extension Log {
    public enum Level: String {
        case verbose = "📢 [VERBOSE]"
        case debug = "🛠 [DEBUG]"
        case info = "💡 [INFO]"
        case warning = "⚠️ [WARNING]"
        case error = "🚨 [ERROR]"
                
        fileprivate var string: String {
             return Log.customLevelHeader[self] ?? self.rawValue
        }
        
        fileprivate func intValue() -> Int {
            let _intValue: [Log.Level: Int] = [
                .verbose: 0,
                .debug: 1,
                .info: 2,
                .warning: 3,
                .error: 4
            ]
            
            return _intValue[self] ?? 4
        }
    }
}

extension Log {
    public enum FormatType {
        /// [Level] ▷ Any...
        case short
        
        /// [Level] file:line funcName ▷ Any...
        case medium
        
        /// Time: [Level] file:line funcName ▷ Any...
        case long
        
        /// Time: [Level] file:line funcName [Thread Name] ▷ Any...
        case full
    }
}

public struct Log {
    
    private static var logLevel: Log.Level = .verbose
    private static var formatType: Log.FormatType = .full
    private static let internalQueue = DispatchQueue(label: "internalPrintQueue")
    private static let dateFormatter = DateFormatter()
    private static var dateFormat: String = "yyyy-MM-dd HH:mm:ss.SSS"
    
    private static var time: String {
        let now = Date()
        Log.dateFormatter.dateFormat = Log.dateFormat
        let dateNow = dateFormatter.string(from: now)
        
        return dateNow
    }
    
    private static var threadName: String {
        if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        } else if let queueName = DispatchQueue.currentQueueLabel, !queueName.isEmpty {
            return queueName
        } else {
            return String(format: "%p", Thread.current)
        }
    }

    /// Custom Level Header
    ///
    /// ex)
    /// ```swift
    ///    Log.config(customLevelHeader: [.verbose : "VERBOSE"])
    ///    log.verbose("Hello, world!")
    ///    // VERBOSE ▷ Hello, world!
    /// ```
    public private(set) static var customLevelHeader = [Log.Level : String]()
    
    /// Separator
    ///
    /// default is " ▷ "
    ///
    /// ex)
    /// ```swift
    ///    Log.config(separator: " : ")
    ///    log.verbose("Hello, world!")
    ///    // 📢 [VERBOSE] : Hello, world!
    /// ```
    public private(set) static var separator = " ▷ "
    
    private init() {}
   
    /// Configration
    /// 
    /// - Parameters:
    ///   - level: Log level. default: Log.Level.verbose
    ///   - customLevelHeader: Custom log level header.
    ///   - formatType: Log String FormatType.  `default`: Log.FormatType.full
    ///   - separator: Separator String. `default`: " ▷ "
    ///   - dateFormat: DateFormatter date fomat string. `default`: yyyy-MM-dd HH:mm:ss.SSS
    ///
    /// ```swift
    ///
    ///    // dateFormat
    ///    Log.config(dateFormat: "yyyy-MM-dd")
    ///    Log.verbose("This is verbose")
    ///    // 2019-11-25: 📢 [VERBOSE] Code.swift:26 method() [com.apple.main-thread] ▷ This is verbose
    ///
    ///    // formatType
    ///    Log.config(formatType: .short)
    ///    Log.verbose("This is verbose")
    ///    // 📢 [VERBOSE] ▷ This is verbose
    ///
    ///    Log.config(formatType: .medium)
    ///    Log.verbose("This is verbose")
    ///    // 📢 [VERBOSE] Code.swift:26 (method()) ▷ This is verbose
    ///
    ///    Log.config(formatType: .long)
    ///    Log.verbose("This is verbose")
    ///    // 2019-11-25: 📢 [VERBOSE] Code.swift:26 (method()) ▷ This is verbose
    ///
    ///    Log.config(formatType: .full)
    ///    Log.verbose("This is verbose")
    ///    // 2019-11-25: 📢 [VERBOSE] Code.swift:26 (method()) [com.apple.main-thread] ▷ This is verbose
    ///
    ///    // customLevelHeader
    ///    Log.config(customLevelHeader: [
    ///      .verbose : "VERBOSE",
    ///      .debug: "DEBUG",
    ///      .info: "INFO",
    ///      .warning: "WARNING",
    ///      .error: "ERROR"
    ///    ])
    ///    log.verbose("Hello, world!")
    ///    // VERBOSE ▷ Hello, world!
    ///
    ///    // separator
    ///    Log.config(separator: ": ")
    ///    log.verbose("Hello, world!")
    ///    // VERBOSE: Hello, world!
    ///
    ///    // level
    ///    Log.config(level: .info)
    ///    Log.verbose("This is verbose")
    ///    Log.debug("This is debug")
    ///    Log.info("This is info")
    ///    Log.warning("This is warning")
    ///    Log.error("This is error")
    ///    // INFO: This is info
    ///    // WARNING: This is warning
    ///    // ERROR: This is error
    /// ```
    public static func congfig(
        level: Log.Level? = nil,
        customLevelHeader: [Log.Level : String]? = nil,
        formatType: Log.FormatType? = nil,
        separator: String? = nil,
        dateFormat: String? = nil
    ) {
        self.logLevel = level ?? self.logLevel
        self.customLevelHeader = customLevelHeader ?? self.customLevelHeader
        self.formatType = formatType ?? self.formatType
        self.separator = separator ?? self.separator
        self.dateFormat = dateFormat ?? self.dateFormat
    }
    
    private static func logString(_ level: Log.Level, fileName: String, line: UInt, funcName: String) -> String {
        let file = fileName.components(separatedBy: "/").last ?? ""
        switch formatType {
        case .short:
            return "\(level.string)"
        case .medium:
            return "\(level.string) \(funcName)"
        case .long:
            return "\(time): \(level.string) \(file):\(line) \(funcName)"
        case .full:
            let thread = threadName
            return "\(time): \(level.string) \(file):\(line) \(funcName) [\(thread)]"
        }
    }
    
    public static func logger(
        _ level: Log.Level,
        fileName: String,
        line: UInt,
        funcName: String,
        printerType: Log.PrinterType,
        output: Any
    ) {
        guard  logLevel.intValue() <= level.intValue() else { return }
        let logString = Log.logString(
            level,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
        
        internalQueue.sync {
            guard let items = output as? [Any] else {
                logPrinter(logString, printerType, value: output)
                return
            }
            
            switch items.count {
            case 0:
                Swift.print(logString)
            case 1:
                logPrinter(logString, printerType, value: items[0])
            default:
                multipleItemLogPrinter(logString, printerType, items: items)
            }
        }
    }
    
    private static func logPrinter(_ logString: String, _ printType: Log.PrinterType, value: Any) {
        switch printType {
        case .debug:
            Swift.print("\(logString)\(separator)", terminator: "")
            Swift.debugPrint(value)
            
        case .dump:
            Swift.print("\(logString)\(separator)")
            Swift.dump(value, name: name(value), indent: 2)
            
        case .default:
            Swift.print("\(logString)\(separator)", terminator: "")
            Swift.print(value)
        }
    }
    
    private static func multipleItemLogPrinter(
        _ logString: String,
        _ printType: Log.PrinterType,
        items: [Any]
    ) {
        switch printType {
        case .debug:
            Swift.print("\(logString) ▽")
            for item in items {
                Swift.debugPrint(item)
            }
            
        case .dump:
            Swift.print("\(logString) ▽")
            for item in items {
                Swift.dump(item, name: name(item), indent: 2)
            }
            
        case .default:
            Swift.print("\(logString) ▽")
            for item in items {
                Swift.print(item)
            }
        }
    }
    
    private static func name(_ value: Any) -> String {
        return "\(type(of: value))"
    }
    
    public static func verbose(
        fileName: String = #file,
        line: UInt = #line,
        funcName: String = #function,
        printBy printerType: Log.PrinterType = .default,
        _ output: Any...
    ) {
        logger(
            .verbose,
            fileName: fileName,
            line: line,
            funcName: funcName,
            printerType: printerType,
            output: output
        )
    }
    
    public static func debug(
        fileName: String = #file,
        line: UInt = #line,
        funcName: String = #function,
        printBy printerType: Log.PrinterType = .default,
        _ output: Any...
    ) {
        logger(
            .debug,
            fileName: fileName,
            line: line,
            funcName: funcName,
            printerType: printerType,
            output: output
        )
    }
    
    public static func info(
        fileName: String = #file,
        line: UInt = #line,
        funcName: String = #function,
        printBy printerType: Log.PrinterType = .default,
        _ output: Any...
    ) {
        logger(
            .info,
            fileName: fileName,
            line: line,
            funcName: funcName,
            printerType: printerType,
            output: output
        )
    }
    
    public static func warning(
        fileName: String = #file,
        line: UInt = #line,
        funcName: String = #function,
        printBy printerType: Log.PrinterType = .default,
        _ output: Any...
    ) {
        logger(
            .warning,
            fileName: fileName,
            line: line,
            funcName: funcName,
            printerType: printerType,
            output: output
        )
    }
    
    public static func error(
        fileName: String = #file,
        line: UInt = #line,
        funcName: String = #function,
        printBy printerType: Log.PrinterType = .default,
        _ output: Any...
    ) {
        logger(
            .error,
            fileName: fileName,
            line: line,
            funcName: funcName,
            printerType: printerType,
            output: output
        )
    }
}
