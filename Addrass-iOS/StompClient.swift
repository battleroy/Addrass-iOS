//
//  StompClient.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 3/4/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import Starscream


public protocol StompSubscriptionsRepository {
    func idForNewSubscription(_ destination: String) -> String
    func unsubscribeByID(_ ID: String) -> Bool
}


public protocol StompClientDelegate: class {
    func stompClientDidConnect(_ client: StompClient)
    func stompClientDidDisconnect(_ client: StompClient)
    func stompClientError(_ client: StompClient, error: Error)

    func stompClientDidReceiveText(_ client: StompClient, text: String?)
}


public class StompClient {
    
    // MARK: Fields
    
    fileprivate var socket: WebSocket
    fileprivate var idsByDestination: [String : NSMutableArray]
    
    weak var delegate: StompClientDelegate?

    
    // MARK: Init
    
    init(url: URL) {
        self.idsByDestination = [String : NSMutableArray]()

        self.socket = WebSocket(url: url)
        self.socket.delegate = self
        
        do {
            let rootCertData = try Data(contentsOf: Bundle.main.url(forResource: "root", withExtension: "der")!)
            self.socket.security = SSLSecurity(certs: [SSLCert(data: rootCertData)], usePublicKeys: false)
        } catch {
            
        }
    }
    
    
    // MARK: Public methods
    
    public func connect() {
        socket.connect()
    }
    
    
    public func disconnect() {
        socket.disconnect()
    }
    
    
    public func subscribe(_ destination: String) {
        let newID = idForNewSubscription(destination)
        let subscribeFrame = StompFrame.SubscribeFrame(destination, id: newID)
        sendFrame(subscribeFrame)
    }
    
    
    public func unsubscribe(_ destination: String) {
        if let existingID = idsByDestination[destination]?.firstObject as? String {
            let unsubscribeFrame = StompFrame.UnsubscribeFrame(existingID)
            if unsubscribeByID(existingID) {
                sendFrame(unsubscribeFrame)
            } else {
                delegate?.stompClientError(self, error: StompError.badUnsubscribeID)
            }
        }
    }
    
    
    public func sendText(_ text: String, destination: String) {
        let textFrame = StompFrame.SendFrame(text, destination: destination)
        sendFrame(textFrame)
    }
    
    
    // MARK: Private methods
    
    fileprivate func sendFrame(_ frame: StompFrame) {
        socket.write(string: frame.description)
    }
    
    
}


extension StompClient: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocket) {
        let stompConnectFrame = StompFrame.ConnectFrame(socket.currentURL.host)
        sendFrame(stompConnectFrame)
    }
    
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        
    }
    
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let receivedFrame = StompFrameParser.parseSocketData(text.data(using: .utf8)!) {
            
            if receivedFrame is StompFrame.ConnectedFrame {
                delegate?.stompClientDidConnect(self)
            } else if let messageFrame = receivedFrame as? StompFrame.MessageFrame {
                delegate?.stompClientDidReceiveText(self, text: messageFrame.bodyText)
            } else if let errorFrame = receivedFrame as? StompFrame.ErrorFrame {
                delegate?.stompClientError(self, error: errorFrame)
            }
            
        } else {
            delegate?.stompClientError(self, error: StompError.badStompFrame)
        }
    }
    
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
    }
    
}


extension StompClient: StompSubscriptionsRepository {
    
    // MARK: StompSubscriptionRepository
    
    public func idForNewSubscription(_ destination: String) -> String {
        var subscriptionsIDs = idsByDestination[destination]
        if subscriptionsIDs == nil {
            idsByDestination[destination] = NSMutableArray()
            subscriptionsIDs = idsByDestination[destination]
        }
        
        subscriptionsIDs!.add("\(destination)-\(subscriptionsIDs!.count)")
        return subscriptionsIDs?.lastObject as! String
    }
    
    
    public func unsubscribeByID(_ ID: String) -> Bool {
        var idWasRemoved = false
        var destinationToRemove: String? = nil
        for (destination, destinationSubIDs) in idsByDestination {
            var subIDIndex: Int?
            destinationSubIDs.enumerateObjects({ (subID, index, shouldStop) in
                if (subID as! String) == ID {
                    subIDIndex = index
                }
            })
            
            if let indexOfRemove = subIDIndex {
                destinationSubIDs.removeObject(at: indexOfRemove)
                idWasRemoved = true
                
                if destinationSubIDs.count == 0 {
                    destinationToRemove = destination
                }
                
                break
            }
        }
        
        if let removeKey = destinationToRemove {
            idsByDestination.removeValue(forKey: removeKey)
        }
        
        return idWasRemoved
    }
    
}
