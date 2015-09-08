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

    // MARK: - Interface
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    
    // MARK: - Properties
    private var session: WCSession!
    
    // MARK: - Calls
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // To configure and activate the session
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
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
    @IBAction func sendToWatch(sender: AnyObject) {
        sendMessage()
    }
}


//MARK: - WatchSessionProtocol -> ViewController
typealias WatchSessionProtocol = ViewController
extension WatchSessionProtocol {
    
    // WCSession Delegate protocol
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        // Reply handler, received message
        let value = message["Message"] as? String
        
        // GCD - Present on the screen
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
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
        session.sendMessage(messageToSend, replyHandler: { (replyMessage) -> Void in
            
            // Reply handler - present the reply message on screen
            let value = replyMessage["Message"] as? String
            
            // GCD - Present on the screen
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.replyLabel.text = value!
            })
            
            }) { (error:NSError) -> Void in
                // Catch any error Handler
                print("error: \(error.localizedDescription)")
        }
    }
}