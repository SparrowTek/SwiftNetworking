//
//  NetworkLogger.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 SparrowTek. All rights reserved.
//

import Foundation

struct NetworkLogger {
    static func log(request: URLRequest) {
        
        log("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { log("\n - - - - - - - - - -  END OUTGOING - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        log(logOutput)
    }
    
    static func log(data: Data?, response: URLResponse?, error: Error?) {
        log("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { log("\n - - - - - - - - - -  END INCOMING - - - - - - - - - - \n") }
        
        guard error == nil else {
            log("Error \(String(describing: error))")
            return
        }
        
        guard let response = response else {
            log("URLResponse is NIL")
            return
        }
        
        if let httpURLResponse = response as? HTTPURLResponse {
            let statusCode = httpURLResponse.statusCode
            let urlAsString = httpURLResponse.url?.absoluteString ?? ""
            let urlComponents = NSURLComponents(string: urlAsString)
            
            let path = "\(urlComponents?.path ?? "")"
            let query = "\(urlComponents?.query ?? "")"
            let host = "\(urlComponents?.host ?? "")"
            
            var logOutput = """
            status code: \(statusCode)
            \(urlAsString) \n\n
            \(path)?\(query) HTTP/1.1 \n
            HOST: \(host)\n
            """
            for (key,value) in httpURLResponse.allHeaderFields {
                logOutput += "\(key): \(value) \n"
            }
            
            log(logOutput)
            
        } else {
            log("\n - - - - - - - - - - NOT HTTPURLResponse - - - - - - - - - - \n \(response)")
        }
        
        if let data = data, let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            log("\(prettyPrintedString)")
        }
    }
    
    static private func log(_ data: String) {
        #if DEBUG
        print(data)
        #endif
    }
}
