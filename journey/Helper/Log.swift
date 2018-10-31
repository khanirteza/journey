//
//  Log.swift
//
//  Created by Khan, Mohammad Irteza (M.) on 5/17/18.
//
import Foundation

class Log {
    
    private enum levelColor: String {
        case verbose = "💜"
        case debug = "💚"
        case info = "💙"
        case warning = "💛"
        case error = "❤️"
    }
    
    private init() {
        
    }
    
    static func debug(_ message: @autoclosure() -> Any,
                      _ file: String = #file, _ function: String = #function, line: Int = #line) {
        customPrint(levelColor: .debug, message: message, file: file, function: function, line: line)
        
    }
    
    static func verbose(_ message: @autoclosure() -> Any,
                        _ file: String = #file, _ function: String = #function, line: Int = #line) {
        customPrint(levelColor: .verbose, message: message, file: file, function: function, line: line)
        
    }
    
    static func info(_ message: @autoclosure() -> Any,
                     _ file: String = #file, _ function: String = #function, line: Int = #line) {
        customPrint(levelColor: .info, message: message, file: file, function: function, line: line)
        
    }
    
    static func warning(_ message: @autoclosure() -> Any,
                        _ file: String = #file, _ function: String = #function, line: Int = #line) {
        customPrint(levelColor: .warning, message: message, file: file, function: function, line: line)
        
    }
    
    static func error(_ message: @autoclosure() -> Any,
                      _ file: String = #file, _ function: String = #function, line: Int = #line) {
        customPrint(levelColor: .error, message: message, file: file, function: function, line: line)
        
    }
    
    private static func customPrint(levelColor: Log.levelColor, message: @autoclosure() -> Any,
                                    file: String = #file, function: String = #function, line: Int = #line) {
        let formattedFileName = getFormattedFileName(file)
        
        let date = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970)
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-ss HH:mm:ss"
        
        print("[\(dateFormatter.string(from: date))] \(levelColor.rawValue) \(formattedFileName).\(function): \(line) - \(message())")
    }
    
    
    private static func getFormattedFileName(_ fileName: String) -> String {
        let fileComponents = fileName.components(separatedBy: "/")
        let fileNameWithExtension = fileComponents.last!
        let formattedFileName = fileNameWithExtension.components(separatedBy: ".").first!
        
        return formattedFileName
    }
}
