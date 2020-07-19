//
//  URL.swift
//  Tiger
//
//  Created by Henrik Thoroe on 17.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation
import Combine
import Network

extension URL: Identifiable {
    
    public enum PingResponse {
        case ok
        case invalidQuery
    }
    
    public enum PingError: Error {
        case noConnection
        case transportLayer(Error)
    }
    
    public var id: String {
        absoluteString.lowercased()
    }
    
    public func ping(completionHandler: @escaping (Result<PingResponse, PingError>) -> Void) {
        var request = URLRequest(url: self, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = "HEAD"
        
        let task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(.transportLayer(error!)))
                return
            }
            
            guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
                completionHandler(.success(.invalidQuery))
                return
            }
            
            completionHandler(.success(.ok))
        }
        
        task.resume()
    }
    
}
