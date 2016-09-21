//
//  InterfaceController.swift
//  WatchOS2-NewAPI-WatchConnectivity-Example WatchKit Extension
//
//  Created by Wlad Dicario on 07/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..code
    }


    // MARK: - Interface
    @IBOutlet var messageLabel: WKInterfaceLabel!
    @IBOutlet var sendButton: WKInterfaceButton!
    
    // MARK: - Properties
    var session : WCSession!
    
    // MARK: - Context Initializer
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }

    // MARK: - Calls
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // To configure and activate the session
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}


//MARK: - WatchActions -> InterfaceController
typealias WatchActions = InterfaceController
extension WatchActions {
    
    // Send message to paired iOS App (Parent)
    @IBAction func sendToParent() {
        sendMessage()
    }
}


//MARK: - WatchSessionProtocol -> InterfaceController
typealias WatchSessionProtocol = InterfaceController
extension WatchSessionProtocol {
    
    // WCSession Delegate protocol
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        // Reply handler, received message
        let value = message["Message"] as? String
        
        // GCD - Present on the screen
        DispatchQueue.main.async { () -> Void in
            self.messageLabel.setText(value!)
        }
        
        // Send a reply
        replyHandler(["Message":"Yes!\niOS 9.0 + WatchOS2 ..AAAAAAmazing!"])
        
    }
}


//MARK: - WatchSessionTasks -> InterfaceController
typealias WatchSessionTasks = InterfaceController
extension WatchSessionTasks {

    // Method to send message to paired iOS App (Parent)
    func sendMessage(){
        // A dictionary of property list values that you want to send.
        let messageToSend = ["Message":"Hey iPhone! I'm reachable!!!"]
        
        // Task : Sends a message immediately to the counterpart and optionally delivers a response
        session.sendMessage(messageToSend, replyHandler: { (replyMessage) in
            
            // Reply handler - present the reply message on screen
            let value = replyMessage["Message"] as? String
            
            // Set message label text with value
            self.messageLabel.setText(value)
            
            }) { (error) in
                // Catch any error Handler
                print("error: \(error.localizedDescription)")
        }
    }
}
