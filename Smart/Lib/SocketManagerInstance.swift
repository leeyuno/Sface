//
//  SocketManagerInstance.swift
//  Smart
//
//  Created by leeyuno on 2018. 2. 2..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import SocketIO

class SocketManagerInstance: NSObject {
    static let sharedInstance = SocketManagerInstance()
    
    let manager = SocketManager(socketURL: URL(string: Library.LibObject.url)!)
    lazy var socket = manager.defaultSocket
    
    func socketConnect() {
        socket.connect()
    }
    
    func socketDisConnect() {
        socket.removeAllHandlers()
        socket.disconnect()
    }
    
    func sendMessages() {
        
    }
    
    func receiveMessages(completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        socket.on("message") { data, act in
            var messageDictionary = [String: Any]()
            
            completionHandler(messageDictionary)
        }
    }
}
