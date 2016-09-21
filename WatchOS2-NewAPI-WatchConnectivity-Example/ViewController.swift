//
//  ViewController.swift
//  WatchOS2-NewAPI-WatchConnectivity-Example
//
//  Created by Wlad Dicario on 07/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        //..
    }

    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //..
    }

    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..
    }


    // MARK: - Interface
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    
    // MARK: - Properties
    fileprivate var session: WCSession!
    
    // MARK: - Calls
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // To configure and activate the session
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//MARK: - PairedActions -> ViewController
typealias PairedActions = ViewController
extension PairedActions {
    
    // Send message to Apple Watch
    @IBAction func sendToWatch(_ sender: AnyObject) {
        sendMessage()
    }
}


//MARK: - WatchSessionProtocol -> ViewController
typealias WatchSessionProtocol = ViewController
extension WatchSessionProtocol {
    
    // WCSession Delegate protocol
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        // Reply handler, received message
        let value = message["Message"] as? String
        
        // GCD - Present on the screen
        DispatchQueue.main.async { () -> Void in
            self.replyLabel.text = value!
        }
        
        // Send a reply
        replyHandler(["Message":"Hey Watch! Nice to meet you!\nWould you like work with me?"])
    }
}


//MARK: - WatchSessionTasks -> ViewController
typealias WatchSessionTasks = ViewController
extension WatchSessionTasks {

    // Method to send message to watchOS
    func sendMessage(){
        // A dictionary of property list values that you want to send.
        let messageToSend = ["Message":"Hi watch, are you here?"]
        
        // Task : Sends a message immediately to the counterpart and optionally delivers a response
        session.sendMessage(messageToSend, replyHandler: { (replyMessage) in
            // Reply handler - present the reply message on screen
            let value = replyMessage["Message"] as? String
            
            // GCD - Present on the screen
            DispatchQueue.main.async(execute: { () -> Void in
                self.replyLabel.text = value!
            })
            
            }) { (error) in
                // Catch any error Handler
                print("error: \(error.localizedDescription)")
        }
    }
}
