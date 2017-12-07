//
//  AbstractRequestLoop.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 15.08.17.
//  Copyright © 2017 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/**
 Class that handles HTTP-request sending by SDK.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
class AbstractRequestLoop {
    
    // MARK: - Constants
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum UnknownError: Error {
        case INTERRUPTED
    }
    
    
    // MARK: - Properties
    private var pauseCondition = NSCondition()
    private let pauseLock = NSRecursiveLock()
    var running = true
    private var currentDataTask: URLSessionDataTask?
    private var paused = true
    private var queue: DispatchQueue?
    private var requests: [WebimRequest]?
    
    
    // MARK: - Methods
    
    func start() {
        guard queue == nil else {
            print("Can't start loop because it is already started.")
            
            return
        }
        
        queue = DispatchQueue(label: "ru.webim.IODispatchQueue")
        queue?.async {
            do {
                try self.run()
            } catch {
                // MARK: TODO
            }
        }
    }
    
    func pause() {
        pauseLock.lock()
        
        paused = true
        
        pauseLock.unlock()
    }
    
    func resume() {
        pauseLock.lock()
        
        paused = false
        pauseCondition.broadcast()
        
        pauseLock.unlock()
    }
    
    func stop() {
        if queue != nil {
            running = false
            resume()
            
            if let currentDataTask = currentDataTask {
                currentDataTask.cancel()
            }
            
            queue = nil
        }
        
        requests?.removeAll()
    }
    
    func run() throws {
        preconditionFailure("This method must be overridden!")
    }
    
    func isRunning() -> Bool {
        return running
    }
    
    func perform(request: URLRequest) throws -> Data {
        var errorCounter = 0.0
        var lastHTTPCode = -1
        
        while isRunning() {
            let startTime = Date()
            var httpCode = 200
            
            let semaphore = DispatchSemaphore(value: 0)
            var receivedData: Data? = nil
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response {
                    httpCode = (response as! HTTPURLResponse).statusCode
                }
                
                if error != nil {
                    semaphore.signal()
                    return
                }
                
                if let data = data {
                    receivedData = data
                }
                
                semaphore.signal()
            }
            currentDataTask = dataTask
            dataTask.resume()
            _ = semaphore.wait(timeout: .distantFuture)
            currentDataTask = nil
            blockUntilPaused()
            
            if !isRunning() {
                break
            }
            
            if let receivedData = receivedData,
                httpCode == 200 {
                return receivedData
            }
            
            if httpCode != 502 { // Bad Gateway
                if httpCode == 413 { // Request Entity Too Large
                    throw SendFileError.FILE_SIZE_EXCEEDED
                }
                
                if httpCode == 415 { // Unsupported Media Type
                    throw SendFileError.FILE_TYPE_NOT_ALLOWED
                }
                
                if httpCode == lastHTTPCode {
                    print("Request failed with HTTP code: \(httpCode)")
                }
                
                errorCounter = 10.0
            }
            
            lastHTTPCode = httpCode
            
            // If request wasn't successful and error isn't fatal, wait some time and try again.
            errorCounter = errorCounter + 1.0
            let sleepTime = ((errorCounter >= 5.0) ? 5.0 : errorCounter) as TimeInterval
            let timeElapsed = Date().timeIntervalSince(startTime)
            if Double(timeElapsed) < Double(sleepTime) {
                let remainingTime = Double(sleepTime) - Double(timeElapsed)
                usleep(useconds_t(remainingTime * 1000000.0))
            }
        }
        
        throw UnknownError.INTERRUPTED
    }
    
    // MARK: Private methods
    private func blockUntilPaused() {
        pauseCondition.lock()
        
        while paused {
            pauseCondition.wait()
        }
        
        pauseCondition.unlock()
    }
    
}
