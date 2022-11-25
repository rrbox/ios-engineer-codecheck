//
//  JavaScriptCommad.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import Foundation

struct Sanitized {
    let body: String
    
    fileprivate init(body: String) {
        self.body = body
    }
}

extension ReadmeData {
    func sanitized() -> Sanitized {
        return Sanitized(body: self.body
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\'", with: "\\'")
            .replacingOccurrences(of: "\"", with: "\\\""))
        
    }
    
}

struct ReadmeInjectionCommand {
    let body: String
    
    fileprivate init(body: String) {
        self.body = body
    }
}

extension Sanitized {
    func injectionCommand() -> ReadmeInjectionCommand {
        return ReadmeInjectionCommand(body: "insert('\(self.body)');")
    }
}
