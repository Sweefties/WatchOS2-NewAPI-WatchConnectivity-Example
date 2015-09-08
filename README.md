![](https://img.shields.io/badge/build-pass-brightgreen.svg?style=flat-square)
![](https://img.shields.io/badge/platform-WatchOS2-ff69b4.svg?style=flat-square)
![](https://img.shields.io/badge/Require-XCode7-lightgrey.svg?style=flat-square)


# WatchOS2 - New API - WatchConnectivity - Example
WatchOS 2 Experiments - New API Components - WatchConnectivity with Paired Devices.

## Example

![](https://raw.githubusercontent.com/Sweefties/WatchOS2-NewAPI-WatchConnectivity-Example/master/source/Apple_Watch_template-WatchConnectivity.jpg)


## Requirements

- >= XCode 7 beta 6~.
- >= Swift 2.
- >= iOS 9.0.

Tested on WatchOS2, iOS 9.0 Simulators, Apple Watch, iPhone 6.

## Usage

To run the example project, download or clone the repo.


### Example Code!


Configure Watch App:

- Drag and drop WKInterfaceButton, WKInterfaceLabel to Interface Controller (Storyboard)
- connect your WKInterfaceButton to your Interface Controller class
- define your WKInterfaceButton IBAction

Configure iOS App:

- Drag and drop UIButton, UILabel to ViewController (Storyboard)
- connect your UIButton to your ViewController class
- define your UIButton IBAction


Example of code in controllers classes WKInterfaceController (for WatchOS) AND ViewController (for iOS App) :

- Add WatchConnectivity Framework
```swift
import WatchConnectivity
```

- Properties
```swift
var session : WCSession!
```

- in willActivate() for Watch Extension AND viewDidLoad() for iOS App
```swift
// To configure and activate the session
if WCSession.isSupported() {
    session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
}
```

- Send message example (iOS App -> Watch)
```swift
// Method to send message to watchOS
@IBAction func sendToWatch(sender: AnyObject) {
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
```

- Send message example (Watch -> iOS App)
```swift
// Send message to paired iOS App (Parent)
@IBAction func sendToParent() {
    // A dictionary of property list values that you want to send.
    let messageToSend = ["Message":"Hey iPhone! I'm reachable!!!"]

    // Task : Sends a message immediately to the counterpart and optionally delivers a response
    session.sendMessage(messageToSend, replyHandler: { (replyMessage) -> Void in

        // Reply handler - present the reply message on screen
        let value = replyMessage["Message"] as? String

        // Set message label text with value
        self.messageLabel.setText(value)

        }) { (error:NSError) -> Void in
            // Catch any error Handler
            print("error: \(error.localizedDescription)")
    }
}
```

- WCSession Protocol example
```swift
// WCSession Delegate protocol
func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {

    // Reply handler, received message
    let value = message["Message"] as? String

    // GCD - Present on the screen
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.messageLabel.setText(value!)
    }

    // Send a reply
    replyHandler(["Message":"Yes!\niOS 9.0 + WatchOS2 ..AAAAAAmazing!"])

}
```


Build and Run WatchApp AND iOS App!
