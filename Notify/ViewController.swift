//
//  ViewController.swift
//  Notify
//
//  Created by Jan Hovland on 24/04/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import UIKit

// SDK required for notifications
import UserNotifications

class ViewController: UIViewController {
    
    var today = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up didEnterBackgroundNotification which is called when the app is set to background
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
   }
    
    @objc func pauseWhenBackground(noti: Notification) {
        fire()
    }
    
    @objc func fire() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        today = dateFormatter.string(from: Date())
        
        print("toDay fra fire() = \(today)")
        
        // #1.1 - Create "the notification's category value--its type."
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "debitOverdraftNotification", actions: [], intentIdentifiers: [], options: [])
        // #1.2 - Register the notification type.
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])
        
        sendNotification(today: today)
        
    }

    // Note that
    func sendNotification(today: String) {
        
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in

            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }

            // create the content and style for the local notification
            let content = UNMutableNotificationContent()

            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
            content.categoryIdentifier = "debitOverdraftNotification"

            content.title = today
            content.body = today
            content.sound = UNNotificationSound.default

            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

        } // end getNotificationSettings

    } // end func sendNotification

} // end class ViewController
