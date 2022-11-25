//
//  WebKit+ReadmeParse.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import WebKit

extension WKWebView {
    func execute(_ command: ReadmeInjectionCommand, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        self.evaluateJavaScript(command.body, completionHandler: completionHandler)
    }
}
