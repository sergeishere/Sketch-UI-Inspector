//
//  OSLog.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 28/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import os.log

extension OSLog {
    
    static public var sketchUIInspectorLog: OSLog {
        return OSLog(subsystem: "com.sergeishere.plugins", category: "Sketch UI Inspector")
    }
}

public func plugin_log(_ message: String = "", filePath: String = #file, line: UInt = #line, function: String = #function,_ args: CVarArg...) {
    let file = URL(fileURLWithPath: filePath).lastPathComponent
    let finalMessage = String(format: message, args)
    os_log("%{public}@ → %{public}@(%u):\n\n%{public}@", log: .sketchUIInspectorLog, type: .default, file,function,line, finalMessage)
}
