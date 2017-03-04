//
//  StompFrame.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 3/4/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation


public class StompConstants {
    
    public struct StompSeparators {
        let LF = "\n"
        let LFLF = "\n\n"
        let NUL = "\0"
        let COLON = ":"
    }
    
    public struct StompHeaders {
        let acceptVersion = "accept-version"
        let host = "host"
        let version = "version"
        let receipt = "receipt"
        let destination = "destination"
        let contentType = "content-type"
        let subscription = "subscription"
        let message = "message"
        let ID = "id"
        let messageID = "message-id"
    }
    
    static let separators = StompSeparators()
    static let headers = StompHeaders()
}


public class StompFrame {
    
    public enum FrameType: String {
        case connect = "CONNECT"
        case connected = "CONNECTED"
        case send = "SEND"
        case subscribe = "SUBSCRIBE"
        case unsubscribe = "UNSUBSCRIBE"
        case message = "MESSAGE"
        case error = "ERROR"
        case disconnect = "DISCONNECT"
    }
    
    
    // MARK: Fields
    
    fileprivate var frameType: FrameType
    public var headers: [String : String]
    fileprivate var body: Data?
    
    
    // MARK: Properties
    
    public var bodyText: String? {
        get {
            guard let data = body else {
                return nil
            }
            
            return String(data: data, encoding: .utf8)
        }
    }
    
    
    public var bodyData: Data? {
        get {
            return body
        }
    }
    
    
    // MARK: Init
    
    init() {
        frameType = .connect
        headers = [String : String]()
    }
    
    
    // MARK: Subclasses
    
    public class ConnectFrame: StompFrame {
        
        init(_ host: String?) {
            super.init()
            frameType = .connect
            
            headers[StompConstants.headers.acceptVersion] = "1.1"
            headers[StompConstants.headers.host] = host
        }
        
    }
    
    
    public class ConnectedFrame: StompFrame {
        
        init(_ version: String?) {
            super.init()
            frameType = .connected
            
            headers[StompConstants.headers.version] = version
        }
        
    }
    
    
    public class DisconnectFrame: StompFrame {
        
        override init() {
            super.init()
            frameType = .disconnect
            
            headers[StompConstants.headers.receipt] = String(arc4random())
        }
        
    }
    
    
    public class SendFrame: StompFrame {
        
        init(_ string: String?, destination: String?) {
            super.init()
            frameType = .send
            
            body = string?.data(using: .utf8)
            headers[StompConstants.headers.destination] = destination
            headers[StompConstants.headers.contentType] = "text/plain"
        }
        
    }
    
    
    public class SubscribeFrame: StompFrame {
        
        init(_ destination: String?, id: String?) {
            super.init()
            frameType = .subscribe
            
            headers[StompConstants.headers.ID] = id
            headers[StompConstants.headers.destination] = destination
        }
        
    }
    
    
    public class UnsubscribeFrame: StompFrame {
        
        init(_ id: String?) {
            super.init()
            frameType = .unsubscribe
            
            headers[StompConstants.headers.ID] = id
        }
        
    }
    
    
    public class MessageFrame: StompFrame {
        
        init(_ subscriptionID: String, messageID: String, destination: String, bodyText: String?) {
            super.init()
            frameType = .message
            
            headers[StompConstants.headers.subscription] = subscriptionID
            headers[StompConstants.headers.messageID] = messageID
            headers[StompConstants.headers.destination] = destination
            headers[StompConstants.headers.contentType] = "text/plain"
            
            body = bodyText?.data(using: .utf8)
        }
        
    }
    
    
    public class ErrorFrame: StompFrame, LocalizedError {
        
        init(_ message: String?) {
            super.init()
            frameType = .error
            
            headers[StompConstants.headers.message] = message
        }
        
        
        // MARK: LocalizedError
        
        public var errorDescription: String? {
            return headers[StompConstants.headers.message]
        }
        
    }
    
}


extension StompFrame: CustomStringConvertible {
    
    public var description: String {
        get {
            var result = "\(frameType.rawValue)\(StompConstants.separators.LF)"
            
            if headers.count > 0 {
                for (headerName, headerValue) in headers {
                    result += "\(headerName)\(StompConstants.separators.COLON)\(headerValue)\(StompConstants.separators.LF)"
                }
                
                result += StompConstants.separators.LF
            }
            
            if let data = bodyData, let dataString = String(data: data, encoding: .utf8) {
                result += dataString
            }
            
            result += StompConstants.separators.NUL
            
            return result
        }
    }
    
}


public class StompFrameParser {
    
    // MARK: Public methods
    
    public static func parseSocketData(_ data: Data) -> StompFrame? {
        guard let messageText = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        guard let messageHeaderIndex = messageText.range(of: StompConstants.separators.LF) else {
            return nil
        }
        
        guard let messageType = StompFrame.FrameType(rawValue: messageText.substring(to: messageHeaderIndex.lowerBound)) else {
            return nil
        }
        
        guard let nulIndex = messageText.range(of: StompConstants.separators.NUL) else {
            return nil
        }
        
        var headers = [String : String]()
        var bodyRange: Range<String.Index>
        if let headersEndIndex = messageText.range(of: StompConstants.separators.LFLF) {
            
            let headerLines = messageText
            .substring(with: messageHeaderIndex.lowerBound..<headersEndIndex.upperBound)
            .components(separatedBy: StompConstants.separators.LF)
            .filter {
                return $0.characters.count > 0
            }
            
            for line in headerLines {
                guard let colonIndex = line.range(of: StompConstants.separators.COLON) else {
                    continue
                }
                
                let headerName = line.substring(to: colonIndex.lowerBound)
                let headerValue = line.substring(from: colonIndex.upperBound)
                
                headers[headerName] = headerValue
            }
            
            bodyRange = headersEndIndex.upperBound..<nulIndex.lowerBound
        } else {
            bodyRange = messageHeaderIndex.upperBound..<nulIndex.lowerBound
        }
        
        let data = messageText.substring(with: bodyRange).data(using: .utf8)
        
        return parseFrame(frameType: messageType, headers: headers, bodyData: data)
    }
    
    
    // MARK: Private methods
    
    private static func parseFrame(frameType type: StompFrame.FrameType, headers: [String : String], bodyData: Data?) -> StompFrame? {
        
        var bodyText: String? = nil
        if let data = bodyData {
            bodyText = String(data: data, encoding: .utf8)
        }
        
        switch type {
        case .connect:
            return StompFrame.ConnectFrame(headers[StompConstants.headers.host])
        case .connected:
            return StompFrame.ConnectedFrame(headers[StompConstants.headers.version])
        case .disconnect:
            return StompFrame.DisconnectFrame()
        case .error:
            return StompFrame.ErrorFrame(headers[StompConstants.headers.message])
        case .message:
            return StompFrame.MessageFrame(
                headers[StompConstants.headers.subscription]!,
                messageID: headers[StompConstants.headers.messageID]!,
                destination: headers[StompConstants.headers.destination]!,
                bodyText: bodyText
            )
        case .send:
            return StompFrame.SendFrame(bodyText, destination: headers[StompConstants.headers.destination])
        case .subscribe:
            return StompFrame.SubscribeFrame(headers[StompConstants.headers.destination], id: headers[StompConstants.headers.ID])
        case .unsubscribe:
            return StompFrame.UnsubscribeFrame(headers[StompConstants.headers.ID])
        }
        
    }
    
}
